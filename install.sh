#!/bin/bash

PWD=$(pwd)

if [[ -e ~/.gitconfig ]]; then
	mv ~/.gitconfig{,.bak}
fi
ln -sf ${PWD}/.gitconfig ~/.gitconfig

if [[ -e ~/.git_template ]]; then
	mv ~/.git_template{,.bak}
fi
ln -sf ${PWD}/git_template ~/.git_template

# if [[ -e ~/.config/xfce4 ]]; then
# 	mv ~/.config/xfce4{,.bak}
# fi
# ln -sf ${PWD}/config/xfce4 ~/.config/xfce4

# install zgen
if [[ ! -d ~/.zgen ]]; then
	git clone https://github.com/tarjoilija/zgen.git ~/.zgen
fi

if [[ -e ~/.zshrc ]]; then
	mv ~/.zshrc{,.bak}
fi
ln -sf ${PWD}/zshrc ~/.zshrc

if [[ -e ~/.zshenv ]]; then
	mv ~/.zshenv{,.bak}
fi
ln -sf ${PWD}/zshenv ~/.zshenv

# bashrc
if [[ ! -e ~/.bashrc ]]; then
	mv ~/.bashrc{,.bak}
fi
ln -sf ${PWD}/bashrc ~/.bashrc

# tmux
if [[ -e ~/.tmux.conf ]]; then
	mv ~/.tmux.conf{,.bak}
fi
ln -sf ${PWD}/tmux.conf ~/.tmux.conf

# tool
if [[ ! -e ~/bin ]]; then
	ln -sf ${PWD}/bin ~/bin
fi

# xmodmap
if [[ ! -e ~/.Xmodmap ]]; then
	ln -sf ${PWD}/tpXmodmap ~/.tpXmodmap
fi
if [[ ! -e ~/.pokerXmodmap ]]; then
	ln -sf ${PWD}/pokerXmodmap ~/.pokerXmodmap
fi
if [[ ! -e ~/.xinitrc ]]; then
	ln -sf ${PWD}/xinitrc ~/.xinitrc
fi
if [[ ! -e /etc/udev/rules.d/80-keyboard.rules ]]; then
	sudo cp ${PWD}/80-keyboard.rules /etc/udev/rules.d/80-keyboard.rules
	sudo udevadm control --reload-rules
fi

# awesome
if [[ -e ~/.config/awesome/rc.lua ]]; then
	mv ~/.config/awesome/rc.lua{,.bak}
fi
mkdir -p ~/.config/awesome
ln -sf ${PWD}/config/awesome/rc.lua ~/.config/awesome/rc.lua

# spacemacs
if [[ -e ~/.spacemacs ]]; then
	mv ~/.spacemacs{,.bak}
fi
ln -sf ${PWD}/spacemacs-conf/spacemacs.symlink ~/.spacemacs

# tpm
if [[ ! -e ~/.tmux/plugins ]]; then
	mkdir -p ~/.tmux/plugins
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
