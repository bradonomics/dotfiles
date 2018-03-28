I've taken liberally from other people's dotfiles. Many functions herein were jacked from other repos and modified to fit my needs. I've uploaded them here as a way of paying back the community (and to keep them backed up, of course).

## /fonts

I keep the Helvetica font family in my .fonts directory so I can see the internet as others do.

Oxygen Mono ([available on Google Fonts](https://fonts.google.com/specimen/Oxygen+Mono)) is my preferred monospace system font. I use it in my terminal, code editor, and other places where l, 1, I, O, and 0 are difficult to tell apart.

## /config

This houses my redshift.conf file. Read more about [Redshift here](http://jonls.dk/redshift/).

## /bin directory

Not really dotfiles, but similar enough.

### install-wordpress.sh

This script installs WordPress. Although if I need to tell you that, you are probably beyond helping. It first checks to see if Apache is running and starts it if it's not. It downloads WordPress, then asks about your MySQL settings to configure your wp-config.php file.

### install-genesis.sh & install-jekyll.sh

These are basically the same. They download theme files, make a few arrangements, and installs Gulp.

### install-wordpress-genesis.sh

This installs WordPress just like install-wordpress.sh but then adds [Genesis Boilerplate](https://github.com/bradonomics/genesis-boilerplate), same as install-genesis.sh.

### webniyom-build-demos.sh

This was a build utility for Jekyll sites. It updated the master branch site.url in `_config.yml`. It then built the site in a different directory and pushed those changes to the demo server, then dumped the changes to the config file.

I no longer use this but keep it here for reference.

### linux-install.sh

This is a script I'm developing to reinstall all my favorite software once I'm ready to move. It's still a work in progress. I'm testing it in virtual machines. If you have any tips (especially why Ruby won't install), please get in touch.
