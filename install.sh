#!/bin/bash

PWD=$(pwd)

if [[ ! -e ~/.gitconfig ]]; then
	ln -sf ${PWD}/.gitconfig ~/.gitconfig
fi

if [[ ! -e ~/.git_template ]]; then
	ln -sf ${PWD}/git_template ~/.git_template
fi
