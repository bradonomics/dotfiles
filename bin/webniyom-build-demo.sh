#!/bin/bash
# ---------------------------------------------------------------------------
# Copyright 2017, Brad West

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as published
# by the Free Software Foundation.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License at <http://www.gnu.org/licenses/> for
# more details.
# ---------------------------------------------------------------------------

PROGNAME=${0##*/}

error_exit() {
  echo -e "${PROGNAME}: ${1:-"Unknown Error"}" >&2
  exit 1
}

# Optional branch check with sed: $(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

# Check if on master branch and abort if not.
if [[ $(git rev-parse --abbrev-ref HEAD) != "master" ]]; then
  error_exit "You should be on the master branch."
fi

# Check for file changes and abort if found.
if [[ -n $(git status -s) ]]; then
  echo ''
  echo 'You have uncommited changes.'
  read -r -p "Do you want to continue without committing these changes? [y/N] " RESPONSE
  if [[ $RESPONSE =~ ^(no|n| ) ]] || [ -z $RESPONSE ]; then
    exit
  fi
fi

# get the template name (directory name)
TEMPLATE=${PWD##*/}

# get the template directory (full path)
TEMPLATE_DIR=${PWD}

# Change site url
# sed -i "s|url: https://demo.webniyom.com|url: https://demo.webniyom.com/$TEMPLATE|" _config.yml

# Remove files from previous build
rm -rf $HOME/Projects/webniyom/demo.webniyom.com/$TEMPLATE

# Create template directory to hold build output
mkdir -p $HOME/Projects/webniyom/demo.webniyom.com/$TEMPLATE

# Build Jekyll and output to the demo directory
JEKYLL_ENV=demo bundle exec jekyll build --destination $HOME/Projects/webniyom/demo.webniyom.com/$TEMPLATE

cd $HOME/Projects/webniyom/demo.webniyom.com/$TEMPLATE || error_exit "Failed to change directories."

# grep for url("/ in css and add the template name so the demo will display images and fonts correctly
grep -rl 'url("/' css/ | xargs sed -i "s|url(\"/|url(\"/$TEMPLATE/|g"

# grep for url('/ in index files and add the template name so the demo will display background images correctly
grep -rl "url('/" --include index.html ./ | xargs sed -i "s|url('/|url('/$TEMPLATE/|g"

# grep for src="/ in index files and add the template name so images and scripts will work in the demo
grep -rl 'src="/' --include index.html ./ | xargs sed -i "s|src=\"/|src=\"/$TEMPLATE/|g"

# grep for href="/ in index files and add the template name so links will work in the demo
grep -rl 'href="/' --include index.html ./ | xargs sed -i "s|href=\"/|href=\"/$TEMPLATE/|g"

git add . --verbose

git commit -m "New build of $TEMPLATE template" --verbose

git push --verbose

# Get back to the directory were we started
cd $TEMPLATE_DIR || error_exit "Failed to change directories."

# Dump the changes to site.url made earlier
# git checkout -- _config.yml

exit
