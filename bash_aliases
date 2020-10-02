#!/bin/bash

alias rebash='source ~/.bashrc'

alias ll='ls -alF'
alias la='ls -A'

alias dot="atom ~/.dotfiles"

# Project directories
alias brad="cd ~/Projects/bradonomics.com"
alias thai="cd ~/Projects/thailandetcetera.com"
alias akaligo="cd ~/Projects/akaligo.com"
alias bedrock="cd ~/Projects/webniyom/bedrock"
alias webniyom="cd ~/Projects/webniyom/webniyom.com"
alias showcase="cd ~/Projects/webniyom/templates/showcase"
alias academy="cd ~/Projects/webniyom/templates/academy"
alias authority="cd ~/Projects/webniyom/templates/authority"
alias phantom="cd ~/Projects/webniyom/templates/phantom"
alias brisket="cd ~/Projects/webniyom/templates/brisket"
alias threshold="cd ~/Projects/webniyom/templates/threshold"
alias prag="cd ~/Projects/pragmatic/rails-studio/flix"

# Populus directories
alias elite="cd ~/Projects/populus/elite"
alias ace="cd ~/Projects/populus/ace-cash-express"

# Git shortcuts
alias stash="git stash --include-untracked"
alias pop="git stash pop"

# APT shortcuts
alias update='sudo apt update'
alias upgrade='sudo apt update && sudo apt -y upgrade'
alias install='sudo apt install'
alias remove='sudo apt remove'

# Services
# alias start-mongo='sudo service mongod start'

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

# Jekyll clean, build, and serve commands, with much wow
alias clean='bundle exec jekyll clean'
alias build='bundle exec jekyll build'
# alias serve='parallelshell "bundle exec jekyll serve --livereload" "~/.local/share/firefox_dev/firefox 'http://localhost:4000/'"'
alias serve='parallelshell "bundle exec jekyll serve --livereload" "google-chrome 'http://localhost:4000/'"'
alias serve-bs='parallelshell "bundle exec jekyll build --watch" "browser-sync start --server '_site' --files '_site' --browser '~/.local/share/firefox_dev/firefox'"'
