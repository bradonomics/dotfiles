I've taken liberally from other people's dotfiles. Many functions herein were jacked from other repos and modified to fit my needs. I've uploaded them here as a way of paying back the community (and to keep them backed up, of course).

## /fonts

Oxygen Mono ([available on Google Fonts](https://fonts.google.com/specimen/Oxygen+Mono)) is my preferred monospace system font. I use it in my terminal, code editor, and other places where l, I, 1, O, and 0 are difficult to tell apart.

Fira and Roboto I use as system fonts.

Helvetica is used often enough by designers, I found it annoying not to have.

Tahoma is used often enough by Windows developers, I found it annoying not to have.

## /config

This houses my redshift.conf file. Read more about [Redshift here](http://jonls.dk/redshift/).

## /bin

### ghpages-deploy.sh

This is my deploy script for Jekyll sites hosted on GitHub Pages; a way to get around unsupported plugins. It does a local build and pushes the built site to the gh-pages branch.

### Everything Else

Most of the scripts in this directory are unused and only kept for reference. The others are probably too specific to be useful to you.
