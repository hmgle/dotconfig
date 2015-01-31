#!/bin/sh

mkdir ~/.local/share/zeitgeist
rmdir ~/.local/share/recently-used.xbel
# no action for the .xbel file, as it will be re-created automatically
sudo mv /etc/xdg/autostart/zeitgeist-datahub.desktop-inactive /etc/xdg/autostart/zeitgeist-datahub.desktop
