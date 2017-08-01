#!/bin/bash

alias rebash='source ~/.bashrc'

alias clr='clear'
alias ll='ls -alF'
alias la='ls -A'

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
alias serve='bundle exec jekyll serve'