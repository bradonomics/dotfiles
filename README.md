# Dotfiles (Linux Mint 17.3)

This repo is a work in progress. I'm getting ready to move to Mint 18.1 (or 18.2 if it gets here by then) and wanted a back up of my dotfiles and scripts. I also thought since I've taken liberally from other's dotfiles I'd load mine here as a way of paying back the community.

## /bin directory

Not really dotfiles, but similar enough I didn't want to create another repo.

### install-wordpress.sh

This script installs WordPress. Although if I need to tell you that, you are probably beyond helping. It first checks to see if Apache is running and starts it if it's not. It downloads WordPress, then asks about your MySQL settings to configure your wp-config.php file.

### install-genesis.sh & install-jekyll.sh

These are basically the same. They download theme files, make a few arrangements, and install Gulp.

### install-wordpress-genesis.sh

This installs WordPress just like install-wordpress.sh but then adds [Genesis Boilerplate](https://github.com/bradonomics/genesis-boilerplate), same as install-genesis.sh.

### webniyom-build-demos.sh

This is a build utility for Jekyll sites. To build [WebNiyom](https://webniyom.com/en/) demos this script updates the master branch site.url in _config.yml. It then builds the site in a different directory and pushes those changes to the demo server, then dumps the changes to the config file.

### linux-install.sh

This is a script I'm developing to reinstall all my favorite software once I'm ready to move. It's still a work in progress. I'm testing it in virtual machines. If you have any tips (especially why Ruby won't install), please get in touch.
