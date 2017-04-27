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
alias cleanup="find . -type f -name '.DS_Store' -ls -delete"
