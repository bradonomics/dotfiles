#!/bin/bash
# ---------------------------------------------------------------------------
# Copyright 2018, Brad West

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

# clean_up() { # Perform pre-exit housekeeping
#   return
# }

error_exit() {
  echo -e "${PROGNAME}: ${1:-"Unknown Error"}" >&2
  # clean_up
  exit 1
}

# graceful_exit() {
#   clean_up
#   exit
# }

signal_exit() { # Handle trapped signals
  case $1 in
    INT)
      error_exit "Program interrupted by user" ;;
    TERM)
      echo -e "\n$PROGNAME: Program terminated" >&2
      exit ;;
    *)
      error_exit "$PROGNAME: Terminating on unknown signal" ;;
  esac
}

# Trap signals
trap "signal_exit TERM" TERM HUP
trap "signal_exit INT"  INT

# Optional branch check with sed: $(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

# Check if on master branch and abort if not.
if [[ $(git rev-parse --abbrev-ref HEAD) != "master" ]]; then
  error_exit "You should be on the master branch."
fi

# Check for uncommited changes and stash if found.
if [[ -n $(git status -s) ]]; then
  git stash --include-untracked
  STASH='yes'
fi

# Remove temp directory from previous build.
rm -rf $HOME/.tmp/jekyll

# Create temp directory to hold build output.
mkdir -p $HOME/.tmp/jekyll

# Build Jekyll and output to temp directory
JEKYLL_ENV=production jekyll build --destination $HOME/.tmp/jekyll

# Checkout gh-pages branch
git checkout gh-pages

# Get directory (so we can copy files into it).
DIRECTORY=${PWD}

# Delete all files in the gh-pages branch (except dot files)
# This ensures that only newly built files get added to the live site.
rm -rf "${DIRECTORY:?}/"*

# Copy files from temp directory
cp -r $HOME/.tmp/jekyll/. $DIRECTORY

# Add files to index and commit
git add . && git commit -m "Deploy changes" --verbose

# Push files to origin
git push

# Checkout master branch
git checkout master

# Unstash
if [[ $(git rev-parse --abbrev-ref HEAD) == "master" ]]; then
  if [ $STASH == 'yes' ]; then
    git stash pop
  fi
fi

exit
