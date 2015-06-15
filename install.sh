#!/bin/bash

PWD=$(pwd)

if [[ ! -e ~/.gitconfig ]]; then
	ln -sf ${PWD}/.gitconfig ~/.gitconfig
fi

if [[ ! -e ~/.git_template ]]; then
	ln -sf ${PWD}/git_template ~/.git_template
fi

if [[ -e ~/.config/xfce4 ]]; then
	mv ~/.config/xfce4{,.bak}
fi
ln -sf ${PWD}/config/xfce4 ~/.config/xfce4

# install oh-my-zsh
if [[ ! -d ~/.oh-my-zsh ]]; then
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh 
fi

if [[ -e ~/.zshrc ]]; then
	mv ~/.zshrc{,.bak}
fi
ln -sf ${PWD}/zshrc ~/.zshrc

# bashrc
if [[ ! -e ~/.bashrc ]]; then
	mv ~/.bashrc{,.bak}
fi
ln -sf ${PWD}/bashrc ~/.bashrc

# tool
if [[ ! -e ~/bin ]]; then
	ln -sf ${PWD}/bin ~/bin
fi

# xmodmap
if [[ ! -e ~/.Xmodmap ]]; then
	ln -sf ${PWD}/Xmodmap ~/.Xmodmap
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
