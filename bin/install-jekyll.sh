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

echo "You should be in the project directory where you want to install your Jekyll project."
echo "If you are not in the project directory, abort this script, create the project directory, and start again."
read -r -p "Are you in the poject directory? [y/N] " RESPONSE

RESPONSE=${RESPONSE,,}

if [[ $RESPONSE =~ ^(no|n| ) ]] | [ -z $RESPONSE ]; then
  graceful_exit
else

  # Download Jekyll Boilerplate theme files
  wget https://github.com/bradonomics/jekyll-boilerplate/archive/master.tar.gz

  # Unzip Jekyll Boilerplate theme files
  tar -zxf master.tar.gz
  cd jekyll-boilerplate-master || error_exit "Failed to change directories."
  cp -rpf * ../
  cd ../ || error_exit "Failed to change directories."

  # Delete Jekyll Boilerplate zip flies
  rm -rf jekyll-boilerplate-master/
  rm -f master.tar.gz

  # Download latest normalize.css file, rename it, and move it into dev/scss directory
  wget https://raw.githubusercontent.com/necolas/normalize.css/master/normalize.css
  mv -f normalize.css _sass/normalize.scss

  # Install gulp
  npm init
  npm install --save-dev gulp gulp-shell gulp-concat gulp-uglify gulp-rename browser-sync

  # Output "finished" note
  echo "Everything should now be setup and ready for you to start your new Jekyll project."

fi

graceful_exit
