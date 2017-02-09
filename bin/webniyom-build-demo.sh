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
  return
  exit 1
}

graceful_exit() {
  return
  exit
}

signal_exit() { # Handle trapped signals
  case $1 in
    INT)
      error_exit "Program interrupted by user" ;;
    TERM)
      echo -e "\n$PROGNAME: Program terminated" >&2
      graceful_exit ;;
    *)
      error_exit "$PROGNAME: Terminating on unknown signal" ;;
  esac
}

# Trap signals
trap "signal_exit TERM" TERM HUP
trap "signal_exit INT"  INT

# Parse command-line
while [[ -n $1 ]]; do
  case $1 in
    -* | --*)
      usage
      error_exit "Unknown option $1" ;;
    *)
      echo "Argument $1 to process..." ;;
  esac
  shift
done

# Optional branch check with sed: $(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

# Check if on master branch and abort if not.
if [[ $(git rev-parse --abbrev-ref HEAD) != "master" ]]; then

  error_exit "You should be on the master branch."

# Check for file changes and abort if found.
elif [[ -n $(git status -s) ]]; then

  error_exit "Commit all your changes before continuing."

else

  # get the template name (directory name)
  TEMPLATE=${PWD##*/}

  sed -i "s|url:.*|url: https://demo.webniyom.com/$TEMPLATE|" _config.yml

  # Build Jekyll and output to the demo.webniyom.com project directory
  jekyll build --destination /home/brad/Projects/demo.webniyom.com/$TEMPLATE

  cd /home/brad/Projects/demo.webniyom.com/$TEMPLATE || error_exit "Failed to change directories."

  # grep for url("/ in css and add the template name so the demo will display images and fonts correctly
  grep -rl 'url("/' css/ | xargs sed -i "s|url(\"/|url(\"/$TEMPLATE/|g"

  # grep for src="/ in index files and add the template name so images and scripts will work in the demo
  grep -rl 'src="/' --include index.html ./ | xargs sed -i "s|src=\"/|src=\"/$TEMPLATE/|g"

  # grep for href="/ in index files and add the template name so links will work in the demo
  grep -rl 'href="/' --include index.html ./ | xargs sed -i "s|href=\"/|href=\"/$TEMPLATE/|g"

  git add .

  git commit -m "new build of $TEMPLATE template" --verbose

  git push

  cd /home/brad/Projects/webniyom-themes/$TEMPLATE || error_exit "Failed to change directories."

  git checkout -- _config.yml

fi

graceful_exit
