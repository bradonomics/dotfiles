#!/bin/bash
# ---------------------------------------------------------------------------
# Copyright 2020, Brad West

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
echo "If you are not in the project directory, abort this script, create the project directory, and start again from there."
echo ''
read -r -p "Are you in the poject directory? [y/N] " RESPONSE
RESPONSE=${RESPONSE,,}
if [[ $RESPONSE =~ ^(no|n| ) ]] | [ -z $RESPONSE ]; then
  exit
fi

# Download Bedrock files
git clone git@gitlab.com:webniyom/bedrock.git

# move files up one level into project directory
cd bedrock || error_exit "Failed to change directories."
cp -rpf ./* ../
cd ../ || error_exit "Failed to change directories."

# Delete empty bedrock directory
rm -rf bedrock/

# Delete .git directory from cloned repo
rm -rf .git/

# Output "finished" note
echo "Everything should now be setup and ready for you to start your new Jekyll project."

exit
