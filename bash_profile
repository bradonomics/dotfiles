#!/bin/bash

# Don't duplicate lines in history (force ignoredups and ignorespace).
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups

# Append history to file, don't overwrite
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Add ~/bin directory to $PATH
if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$PATH";
fi

# Add Ruby directories to $PATH
if [ -d "$HOME/.rbenv" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
  export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
fi

# Add local NPM directory to $PATH
if [ -d "$HOME/.npm" ]; then
  export PATH="$HOME/.npm/bin:$PATH"
fi

# WP CLI Auto Complete
if [ -f "$HOME/.wp-completion.bash" ]; then
  . "$HOME/.wp-completion.bash"
fi

# Alias definitions
if [ -f "$HOME/.bash_aliases" ]; then
  . "$HOME/.bash_aliases"
fi

# Functions
if [ -f "$HOME/.functions" ]; then
  . "$HOME/.functions"
fi

# Run bash-prompt with git
if [ -f "$HOME/.bash_prompt" ]; then
  . "$HOME/.bash_prompt"
fi

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
