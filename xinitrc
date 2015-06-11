#!/bin/sh

if [ -s $HOME/.Xmodmap ]; then
	/usr/bin/xmodmap $HOME/.Xmodmap
fi
