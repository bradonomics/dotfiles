# Dotfiles (Linux Mint 17.3)

This repo is a work in progress. I'm getting ready to move to Mint 18.1 (or 18.2 if it gets here by then) and wanted a back up of my dotfiles and scripts. I also thought since I've taken liberally from other's dotfiles I'd load mine here as a way of paying back the community.

## /bin directory

Not really dotfiles, but similar enough I didn't want to create another repo.

### install-wordpress.sh

This script installs WordPress. Although if I need to tell you that, you are probably beyond helping. It first checks to see if Apache is running and starts it if it's not. It downloads WordPress, then asks about your MySQL settings to configure your wp-config.php file.

### install-genesis-boilerplate.sh & install-jekyll-boilerplate.sh

These are basically the same. They download theme files, make a few arrangements, and install Gulp.

### install-wordpress-genesis.sh

This is a combination of install-wordpress.sh and install-genesis-boilerplate.sh.

### start-apache.sh & stop-apache.sh

You'll notice they use different methods to find the service. I'm not sure that one is better than the other, but I keep both for reference.

### webniyom-build-demos.sh

This is just a build utility for Jekyll sites. In my [WebNiyom](https://webniyom.com/en/) projects I keep a branch called template which is a copy of master except for the _config.yml file which holds the site.url for the demo. After making changes that get merged to master, I run this script to build the site in a different directory and push those changes to the server to demo the changes.

### linux-install.sh

This is a script I'm developing to reinstall all my favorite software once I'm ready to move. It's still a work in progress. I'm testing it in virtual machines. If you have any tips (especially why Ruby won't install), please get in touch.
