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

echo "You should be in the directory where you want to install your Jekyll project."
echo "If you are not in the project directory, abort this script, create the project directory, and start again."
read -r -p "Are you in the poject directory? [y/N] " RESPONSE
# RESPONSE=${RESPONSE,,}
if [[ $RESPONSE =~ ^(no|n| ) ]] || [ -z $RESPONSE ]; then
  exit
fi

# Download Jekyll Boilerplate theme files
wget https://github.com/bradonomics/jekyll-boilerplate/archive/master.tar.gz

# Unzip Jekyll Boilerplate theme files
tar -zxf master.tar.gz
cd jekyll-boilerplate-master || error_exit "Could not change directories."
cp -rpf ./* ../
cd ../ || error_exit "Could not change directories."

# Delete Jekyll Boilerplate zip flies
rm -rf jekyll-boilerplate-master/
rm -f master.tar.gz

# Output "finished" note
echo "Everything should now be setup and ready for you to start your new Jekyll project."

exit
