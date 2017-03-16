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

echo "You should be in the themes directory not in the project directory."
echo "If you already created the project directory, abort this script, delete the project directory, and start again in wp-content/themes."
read -r -p "Are you in the themes directory? [y/N] " RESPONSE

RESPONSE=${RESPONSE,,}

if [[ $RESPONSE =~ ^(no|n| ) ]] | [ -z $RESPONSE ]; then
  graceful_exit
else

  # Get the project name
  echo -ne "What is the project name (child theme directory name): "
  read -s PROJECTNAME

  # Download Genesis Boilerplate theme files
  wget https://github.com/bradonomics/genesis-boilerplate/archive/master.tar.gz

  # Unzip Genesis Boilerplate theme files
  tar zxf master.tar.gz && mv genesis-boilerplate-master $PROJECTNAME

  # Delete Genesis Boilerplate zip flies
  rm -f master.tar.gz

  # Move into child theme directory
  cd $PROJECTNAME || error_exit "Failed to change directories."

  # Download latest normalize.css file, rename it, and move it into dev/scss directory
  wget https://raw.githubusercontent.com/necolas/normalize.css/master/normalize.css
  mv -f normalize.css dev/scss/_normalize.scss

  # Install gulp
  npm init
  npm install --save-dev gulp gulp-sass gulp-autoprefixer gulp-cssnano gulp-concat gulp-uglify gulp-rename browser-sync

  # Add project name to gulpfile
  sed -i "s/geneplate/${PROJECTNAME}/g" "gulpfile.js"

  # Build style.css
  gulp css

  # Check if WP CLI is installed and activate Genesis Boilerplate theme
  if command -v wp >/dev/null; then
    wp theme activate $DATABASENAME
  fi

  # Output "finished" note
  echo "Everything should now be setup and ready for you to start your new Genesis child theme."
  echo "If you don't have WP CLI installed you'll need to activate your child theme before it'll work."

fi

graceful_exit
