#!/bin/sh

/usr/bin/lsusb > /home/gle/xinilog0.log 2>&1
ls -l /dev/input/by-id > /home/gle/xinilog2.log 2>&1

if [ -e /dev/input/by-id/usb-Heng_Yu_Technology_Poker_II-event-kbd ]; then
	/usr/bin/xmodmap $HOME/.pokerXmodmap
	exit 0
fi
if [ -s $HOME/.Xmodmap ]; then
	/usr/bin/xmodmap $HOME/.pcXmodmap
fi
