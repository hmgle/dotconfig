#!/bin/sh

# swap Esc CPAS_LOCK grave key
xmodmap -e "clear Lock"
xmodmap -e "keycode 66 = Escape"
xmodmap -e "keycode 49 = Caps_Lock"
xmodmap -e "keycode 9 = grave asciitilde"
xmodmap -e "add Lock = Caps_Lock"
xmodmap -e "keycode 135 ="

xmodmap -e "keycode 64 = Super_L"
xmodmap -e "keycode 133 = Alt_L"

xmodmap -e "clear control"
xmodmap -e "clear mod1"
xmodmap -e "clear mod2"
xmodmap -e "clear mod3"
xmodmap -e "clear mod4"
xmodmap -e "clear mod5"

xmodmap -e "add control = Control_L"
xmodmap -e "add control = Super_L"
xmodmap -e "add control = Control_R"

xmodmap -e "add mod1 = Alt_L"
xmodmap -e "add mod1 = Alt_R"
xmodmap -e "add mod1 = Meta_L"

xmodmap -e "add mod2 = Num_Lock"
xmodmap -e "add mod4 = Super_R"
xmodmap -e "add mod4 = Hyper_L"
xmodmap -e "add mod5 = ISO_Level3_Shift"
xmodmap -e "add mod5 = Mode_switch"
