#!/bin/bash

# Add ~/bin directory to $PATH
if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$PATH";
fi

# Add Ruby directories to $PATH
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"

# WP CLI Auto Complete
source ~/.wp-completion.bash

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
