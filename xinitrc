#!/bin/sh

if [ -e /dev/input/by-id/usb-Heng_Yu_Technology_Poker_II-event-kbd ]; then
	exit 0
fi
if [ -s $HOME/.Xmodmap ]; then
	/usr/bin/xmodmap $HOME/.Xmodmap
fi
