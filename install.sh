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

# tmux
if [[ -e ~/.tmux.conf ]]; then
	mv ~/.tmux.conf{,.bak}
fi
ln -sf ${PWD}/tmux.conf ~/.tmux.conf

# tool
if [[ ! -e ~/bin ]]; then
	ln -sf ${PWD}/bin ~/bin
fi

# tpm
if [[ ! -e ~/.tmux/plugins ]]; then
	mkdir -p ~/.tmux/plugins
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [[ -e ~/.linuxify ]]; then
	mv ~/.linuxify{,.bak}
fi
ln -sf "${PWD}"/macos_etc/linuxify ~/.linuxify
