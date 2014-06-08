#!/bin/bash

PWD=$(pwd)

if [[ ! -e ~/.gitconfig ]]; then
	ln -sf ${PWD}/.gitconfig ~/.gitconfig
fi
