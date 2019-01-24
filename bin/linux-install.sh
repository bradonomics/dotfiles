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

error_exit() {
  echo -e "\n\n${1:-"Unknown Error"}\n\n" >&2
  exit 1
}

# Check for root UID
if [[ $(id -u) != 0 ]]; then
  error_exit "You must use 'sudo' to run this script."
fi

# Check for dotfiles
read -r -p "Have you added your dotfiles? [y/N]" DOTFILES_RESPONSE
DOTFILES_RESPONSE=${DOTFILES_RESPONSE,,}
if [[ $DOTFILES_RESPONSE =~ ^(no|n| ) ]] | [ -z $DOTFILES_RESPONSE ]; then
  error_exit "You must install your dotfiles first or the Ruby install will fail."
fi

# Check for SSH keys and add if available
read -r -p "Do you have your private SSH keys on this machine? [Y/n]" KEYS_RESPONSE
KEYS_RESPONSE=${KEYS_RESPONSE,,}
if [[ $KEYS_RESPONSE =~ ^(yes|y| ) ]] | [ -z $KEYS_RESPONSE ]; then
  read -r -p "Where are your SSH keys? (ex: /home/brad/.ssh/id_rsa): " KEYS_LOCATION
  sudo -H -u ${SUDO_USER} bash -c "ssh-add $KEYS_LOCATION"
fi

# Array of packages to remove with a single apt remove command
apt_package_remove_list=(
  rhythmbox
  pidgin
  brasero
  brasero-cdrkit
  hexchat
  thunderbird
  transmission-gtk
  cheese
  aisleriot
  gnome-mahjongg
  gnome-mines
  gnome-sudoku
)

# Array of PPAs to add with a single add-apt-repository command
ppa_install_list=(
  ppa:deluge-team/ppa
  ppa:maarten-baert/simplescreenrecorder
  # ppa:numix/ppa
  ppa:oranchelo/oranchelo-icon-theme
  ppa:system76/pop
  ppa:embrosyn/cinnamon
)

# Array of packages to install with a single apt install command
apt_package_install_list=(
  gdebi
  curl
  cinnamon
  atom
  git
  deluge
  guake
  simplescreenrecorder
  # numix-icon-theme
  oranchelo-icon-theme
  pop-theme
  skype
  redshift
  libssl-dev
  libreadline-dev
  zlib1g-dev
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

  # Add Canonical Partner Repos
  add-apt-repository -y "deb http://archive.canonical.com/ubuntu $(lsb_release -sc) partner"

  # Add Atom Code Editor
  wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | apt-key add -
  sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
}

package_install() {
  # Update all of the package references before installing anything
  apt update

  # Install apt packages
  for package in "${apt_package_install_list[@]}"; do
    apt install -y $package;
  done

  # Install Google Chrome
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  gdebi --non-interactive google-chrome-stable_current_amd64.deb
  rm -f google-chrome-stable_current_amd64.deb

  # Install Calibre
  wget -nv -O- https://download.calibre-ebook.com/linux-installer.py | python -c "import sys; main=lambda:sys.stderr.write('Download failed\n'); exec(sys.stdin.read()); main()"

  # Install GitKraken
  wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
  gdebi --non-interactive gitkraken-amd64.deb
  rm -f gitkraken-amd64.deb

  # Install Mint-Y Theme Files
  wget http://packages.linuxmint.com/pool/main/m/mint-y-theme/mint-y-theme_1.2.3_all.deb
  gdebi --non-interactive mint-y-theme_1.2.3_all.deb
  rm -f mint-y-theme_1.2.3_all.deb

  # Install WP CLI
  wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp
  wget https://github.com/wp-cli/wp-cli/raw/master/utils/wp-completion.bash
  mv -f wp-completion.bash $HOME/.wp-completion.bash

  # Install Node
  curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
  apt install -y nodejs build-essential

  # Run Upgrader
  apt upgrade -y

  # Clean up apt caches
  apt autoclean
}

# Remove all the unwanted software installed by default
package_remove

# Add all PPAs
ppa_install

# Install new software
package_install


## Install LAMP

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

# Clone rbenv into ~/.rbenv
sudo -H -u ${SUDO_USER} bash -c "git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv"

# Update path after cloning rbenv
sudo -H -u ${SUDO_USER} bash -c "source $HOME/.bashrc"

# Clone ruby-build into ~/.rbenv/plugins/ruby-build
sudo -H -u ${SUDO_USER} bash -c "git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build"

# Update path after cloning ruby-build
sudo -H -u ${SUDO_USER} bash -c "source $HOME/.bashrc"

# Install the latest version of Ruby and set it globally.
sudo -H -u ${SUDO_USER} bash -c "rbenv install 2.5.3"
sudo -H -u ${SUDO_USER} bash -c "rbenv global 2.5.3"

# Install Bundler
sudo -H -u ${SUDO_USER} bash -c "gem install bundler"


## Install NPM

# Make ~/.npm directory for global packages
if [ ! -d "$HOME/.npm" ]; then
  sudo -H -u ${SUDO_USER} bash -c "mkdir $HOME/.npm"
fi

# Set npm config to new ~/.npm directory
sudo -H -u ${SUDO_USER} bash -c "npm config set prefix '$HOME/.npm'"

# Install parallelshell and browser-sync NPM packages globally
sudo -H -u ${SUDO_USER} bash -c "npm install --global parallelshell browser-sync"

exit
