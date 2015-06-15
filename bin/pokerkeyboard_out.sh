#!/bin/sh

/bin/sleep 0.2
if [ ! -e /dev/input/by-id/usb-Heng_Yu_Technology_Poker_II-event-kbd ]; then
    sudo -u gle /usr/bin/xmodmap -display :0 /home/gle/.Xmodmap >/dev/null 2>&1 &
fi
