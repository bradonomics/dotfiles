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

# Check for root UID
if [[ $(id -u) != 0 ]]; then
  error_exit "You must use `sudo` to run this script."
fi

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

# Array of packages to remove with a single apt remove command
apt_package_remove_list=(
  brasero
  brasero-cdrkit
  gimp
  hexchat
  # libreoffice-draw
  # libreoffice-math
  pidgin
  rhythmbox
  thunderbird
  transmission-gtk
  laptop-mode-tools
)

# Array of PPAs to add with a single add-apt-repository command
ppa_install_list=(
  ppa:git-core/ppa
  ppa:deluge-team/ppa
  ppa:linrunner/tlp
  ppa:maarten-baert/simplescreenrecorder
  ppa:pj-assis/ppa
  ppa:webupd8team/atom
  ppa:webupd8team/unstable
  ppa:numix/ppa
)

# Array of packages to install with a single apt install command
apt_package_install_list=(
  atom
  git
  git-core
  deluge
  tlp # TLP (Power Settings)
  tlp-rdw
  guake
  pyroom
  guvcview
  simplescreenrecorder
  numix-icon-theme
  numix-icon-theme-square
  nodejs
  build-essential
  skype
)

package_remove() {
  # Remove packages
  for package in "${apt_package_remove_list[@]}"; do
    apt purge -y $package;
  done

  # Clear all the dependencies from the uninstall above.
  apt autoremove
}

ppa_install() {
  # Add PPAs
  for ppa in "${ppa_install_list[@]}"; do
    add-apt-repository -y $ppa;
  done

  # Add additional repos
  curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
}

package_install() {
  # Update all of the package references before installing anything
  apt update

  # Install required packages
  for package in "${apt_package_install_list[@]}"; do
    apt install -y $package;
  done

  # Clean up apt caches
  apt-get clean
}

# Remove all the unwanted software installed by default.
package_remove

# Open the Mint Updater.
mintupdate

# Pause the script so the Mint update options can be set.
echo ""
echo "Go to the Linux Mint updater and select your update policy."
echo "Using the Mint Updater install the avaliable updates."
echo ""
read -p "Then press the [Enter] key to restart this script."

# Add all PPAs
ppa_install

# Install new software
package_install

# Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
gdebi --non-interactive google-chrome-stable_current_amd64.deb
rm -f google-chrome-stable_current_amd64.deb

# Install Skype for Linux Alpha
wget https://repo.skype.com/latest/skypeforlinux-64-alpha.deb
gdebi --non-interactive skypeforlinux-64-alpha.deb
rm -f skypeforlinux-64-alpha.deb

# Install Calibre
wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"

# Install GitKraken
wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
gdebi --non-interactive gitkraken-amd64.deb
rm -f gitkraken-amd64.deb

# Install WP CLI
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
wget https://github.com/wp-cli/wp-cli/raw/master/utils/wp-completion.bash
mv -f wp-completion.bash $HOME/.wp-completion.bash

# Install Gulp
npm install --global gulp-cli

# Install Atom Sync Settings package
apm install sync-settings

# Change system settings
# Set Number of Workspaces to 2:
gsettings set org.cinnamon.desktop.wm.preferences num-workspaces 2

# exit
graceful_exit


# Install Apache
# apt install -y apache2
# echo "127.0.0.1    local.dev" | tee --append /etc/hosts
# adduser $USER www-data
# chown -R "$USER":www-data /var/www
# sed -i "s|export APACHE_RUN_USER=.*|export APACHE_RUN_USER=$USER|" /etc/apache2/envvars
# sed -i "/<\/VirtualHost>/ { N; s/<\/VirtualHost>\n/\n    <Directory \/var\/www\/html>\n      Options Indexes FollowSymLinks MultiViews\n      AllowOverride All\n      Order allow,deny\n      allow from all\n        <\/Directory>\n\n&/ }" /etc/apache2/sites-available/000-default.conf

# Install PHP
# apt install -y php
# touch /var/www/html/phpinfo.php
# echo -e "<?php\n\nphpinfo();" | tee /var/www/html/phpinfo.php

# Install MySQL
# apt install -y mysql-server

# Install phpMyAdmin
# apt install -y phpmyadmin


# Install Ruby
# apt install zlib1g-dev libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
#
# git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv
# git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build
#
# rbenv install 2.4.0
# rbenv global 2.4.0
# gem install bundler

# Install Jekyll
# gem install jekyll


# Install Redshift
# apt install libxcb1-dev libxcb-randr0-dev libx11-dev intltool
# wget https://github.com/jonls/redshift/releases/download/v1.11/redshift-1.11.tar.xz
# tar xf redshift-1.11.tar.xz
# cd redshift-1.11 || error_exit
# ./configure --enable-randr --enable-gui --enable-ubuntu \
#     --with-systemduserunitdir=$HOME/.config/systemd/user
# make
# make install
# cd $HOME || error_exit
# rm -rf redshift-1.11
# rm -f redshift-1.11.tar.xz

# Unable to get this to work. Getting error:
# checking whether the C compiler works... no
# configure: error: in `/home/brad/redshift-1.11':
# configure: error: C compiler cannot create executables
# See `config.log' for more details

