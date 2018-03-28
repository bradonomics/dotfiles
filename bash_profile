#!/bin/bash

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
  source ~/.wp-completion.bash
fi

# Alias definitions
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Functions
if [ -f ~/.functions ]; then
  . ~/.functions
fi

# Run bash-prompt with git
if [ -f ~/.bash_prompt ]; then
  . ~/.bash_prompt
fi
