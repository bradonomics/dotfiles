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

# Add Python directories to $PATH
if [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
  fi
fi

# Add NPM directory to $PATH
if [ -d "$HOME/.npm" ]; then
  export PATH="$HOME/.npm/bin:$PATH"
fi

# WP CLI Auto Complete
if [ -f "$HOME/.wp-completion.bash" ]; then
  # shellcheck source=/home/brad/
  . "$HOME/.wp-completion.bash"
fi

# Alias definitions
if [ -f "$HOME/.bash_aliases" ]; then
  # shellcheck source=/home/brad/
  . "$HOME/.bash_aliases"
fi

# Functions
if [ -f "$HOME/.functions" ]; then
  # shellcheck source=/home/brad/
  . "$HOME/.functions"
fi

# Git enabled bash-prompt
if [ -f "$HOME/.bash_prompt" ]; then
  # shellcheck source=/home/brad/
  . "$HOME/.bash_prompt"
fi

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi
