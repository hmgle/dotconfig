#!/bin/sh

sudo mv /etc/xdg/autostart/zeitgeist-datahub.desktop /etc/xdg/autostart/zeitgeist-datahub.desktop-inactive
rm ~/.local/share/recently-used.xbel
mkdir ~/.local/share/recently-used.xbel
rm -rf ~/.local/share/zeitgeist
