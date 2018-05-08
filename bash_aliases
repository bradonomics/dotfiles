#!/bin/bash

alias rebash='source ~/.bashrc'

alias ll='ls -alF'
alias la='ls -A'

alias dot="cd ~/.dotfiles"
alias tt="cd ~/Projects/travel-tripper"

# Git shortcuts
alias stash="git stash --include-untracked"
alias pop="git stash pop"

# APT shortcuts
alias update='sudo apt update'
alias install='sudo apt install'
alias remove='sudo apt remove'

# Make echo $PATH readable
alias path='echo $PATH | tr ":" "\n"'

# A ipconfig /flushdns equivalent
alias flushdns='sudo /etc/init.d/dns-clean restart && /etc/init.d/networking force-reload'

# Delete those stupid Mac .DS_Store files
alias clean="find . -type f -name '.DS_Store' -ls -delete"

# Get External IP
alias ip='curl ipinfo.io/ip'

# Get Local IPs
alias iplocal="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# Speedtest
alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip'

# Jekyll build and serve commands when using Bundler
alias build='bundle exec jekyll build'
alias serve='parallelshell "bundle exec jekyll build --watch" "browser-sync start --server '_site' --files '_site'"'

# Jekyll build and serve commands for sites with {{ site.url }} in file paths
alias build-latest='jekyll build --config _config.yml,_config-dev.yml'
alias serve-latest='parallelshell "jekyll build --watch --config _config.yml,_config-dev.yml" "browser-sync start --server '_site' --files '_site'"'
