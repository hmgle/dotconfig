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
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh 
if [[ -e ~/.zshrc ]]; then
	mv ~/.zshrc{,.bak}
fi
ln -sf ${PWD}/zshrc ~/.zshrc
