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
    tar -zxf latest.tar.gz
    cd wordpress || error_exit "Failed to change directories."
    cp -rpf ./* ../
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

fi

graceful_exit
