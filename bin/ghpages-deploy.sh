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

clean_up() { # Perform pre-exit housekeeping
  return
}

error_exit() {
  echo -e "${PROGNAME}: ${1:-"Unknown Error"}" >&2
  clean_up
  exit 1
}

graceful_exit() {
  clean_up
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
fi

# Check for file changes and abort if found.
if [[ -n $(git status -s) ]]; then
  error_exit "Commit all your changes before continuing."
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

# Copy files from temp directory (overwriting existing)
cp -r $HOME/.tmp/jekyll/. $DIRECTORY

# Add files to index, commit, and push to origin
git add . && git commit -m "Deploy changes" --verbose

# Checkout master branch
git checkout master

graceful_exit
