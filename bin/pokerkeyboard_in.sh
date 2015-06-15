#!/bin/sh

/bin/sleep 0.2 && sudo -u gle /usr/bin/xmodmap -display :0 /home/gle/.pokerXmodmap >/dev/null 2>&1 &
# /bin/sleep 1 && /usr/bin/xmodmap /home/gle/code_repo/misc/dotconfig/pokerXmodmap >/dev/null 2>&1 & # no work
# /bin/sleep 0.2 && /usr/bin/xmodmap -display :0 /home/gle/code_repo/misc/dotconfig/pokerXmodmap >/dev/null 2>&1 & # not work
# /bin/sleep 0.2 && sudo -u gle /usr/bin/xmodmap /home/gle/code_repo/misc/dotconfig/pokerXmodmap >/dev/null 2>&1 & # not work
