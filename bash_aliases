#!/bin/bash

alias rebash='source ~/.bashrc'

alias ll='ls -alF'
alias la='ls -A'

alias dot="cd ~/.dotfiles"
alias brad="cd ~/Projects/bradonomics.com"
alias thai="cd ~/Projects/thailandetcetera.com"

# Git shortcuts
alias stash="git stash --include-untracked"
alias pop="git stash pop"

# APT shortcuts
alias update='sudo apt update'
alias install='sudo apt install'
alias remove='sudo apt remove'

# Services
alias start-mongo='sudo service mongod start'

# Make echo $PATH readable
alias path='echo $PATH | tr ":" "\n"'

# ipconfig-ish equivalent
alias ipconfig='nmcli device show eno1 | grep IP4'

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

# Jekyll build and serve commands, with much wow
alias build='bundle exec jekyll build --config _config.yml,_config-dev.yml'
alias serve='parallelshell "bundle exec jekyll build --watch --config _config.yml,_config-dev.yml" "browser-sync start --server '_site' --files '_site'"'
