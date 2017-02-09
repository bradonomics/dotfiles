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

echo "You should be in the project directory where you want to install WordPress, not in the /html directory."
echo "If you are not in the project directory, abort this script, create the project directory, and start again."
read -r -p "Are you in the poject directory? [y/N] " RESPONSE

RESPONSE=${RESPONSE,,}

if [[ $RESPONSE =~ ^(no|n| ) ]] | [ -z $RESPONSE ]; then
  graceful_exit
else

  # Check if Apache is running and start it if not
  START="sudo service apache2 start"
  PGREP="/usr/bin/pgrep" # path to pgrep command
  HTTPD="apache2" # Httpd daemon name
  $PGREP ${HTTPD} # find httpd process id
  if [ $? -ne 0 ]; then # if apache is not running
    $START
  fi

  # Get the directory name for use as the MySQL database name
  DATABASENAME=${PWD##*/}

  # Ask for MySQL root password
  echo -ne "What is the password for your MySQL root account: "
  read -s MYSQLPASS

  # Create the database
  mysql -u root -p"$MYSQLPASS" -e "CREATE DATABASE IF NOT EXISTS \`$DATABASENAME\`;"

  # Check if WP CLI is installed and use it if so
  if command -v wp >/dev/null; then

    # Download latest WordPress
    wp core download

    # Create a wp-config.php file
    wp core config --dbname=$DATABASENAME --dbuser=root --dbpass=$MYSQLPASS

    # Do the WordPress Install
    wp core install --url="http://local.dev/$DATABASENAME" --title="$DATABASENAME" --admin_user="brad" --admin_password="brad" --admin_email="not@relevent.com"

  else # If WP CLI isn't istalled do it manually

    # Download latest WordPress
    wget http://wordpress.org/latest.tar.gz

    # Unzip WordPress files
    tar zxf latest.tar.gz
    cd wordpress || error_exit "Failed to change directories."
    cp -rpf * ../
    cd ../ || error_exit "Failed to change directories."
    rm -rf wordpress/
    rm -f latest.tar.gz

    # Create wp-config.php from wp-config-sample.php
    cp wp-config-sample.php wp-config.php

    # Add database name to wp-config.php
    sed -i "s/database_name_here/${DATABASENAME}/g" "wp-config.php"

    # Add database username to wp-config.php
    sed -i "s/username_here/root/g" "wp-config.php"

    # Add MySQL root password to add to wp-config.php
    sed -i "s/password_here/${MYSQLPASS}/g" "wp-config.php"

  fi

  # Move to WordPress themes direcory
  cd wp-content/themes || error_exit "Failed to change directories."

  # Delete all other themes
  rm -R -- */

  # Copy Genesis Framework files
  PWD=$(pwd)
  cp -p "$(find /home/brad/Downloads/Software -name 'genesis*.zip')" $PWD

  # Unzip Genesis Framework files
  unzip genesis*.zip && rm -f genesis*.zip

  # Download Genesis Boilerplate theme files
  wget https://github.com/bradonomics/genesis-boilerplate/archive/master.tar.gz

  # Unzip Genesis Boilerplate theme files
  tar -zxf master.tar.gz && mv genesis-boilerplate-master $DATABASENAME

  # Delete Genesis Boilerplate zip flies
  rm -f master.tar.gz

  # Move into child theme directory
  cd $DATABASENAME || error_exit "Failed to change directories."

  # Download latest normalize.css file, rename it, and move it into dev/scss directory
  wget https://raw.githubusercontent.com/necolas/normalize.css/master/normalize.css
  mv -f normalize.css dev/scss/_normalize.scss

  # Install gulp
  npm init
  npm install --save-dev gulp gulp-sass gulp-autoprefixer gulp-cssnano gulp-concat gulp-uglify gulp-rename browser-sync

  # Add project name (database name) to gulpfile
  sed -i "s/geneplate/${DATABASENAME}/g" "gulpfile.js"

  # Build style.css so the theme will load in the WordPress dashboard
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
