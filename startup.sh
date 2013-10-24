#!/usr/bin/env bash

cp ./.bash_profile ~/.bash_profile
cp ./.bashrc ~/.bashrc
cp ./.gitconfig ~/.gitconfig
cp ./.gitignore ~/.gitignore
cp ./.gitignore_global ~/.gitignore_global
cp ./.osx_always ~/.osx_always
cp ./.profile ~/.profile
cp ./.npmrc ~/.npmrc

mkdir -p ~/.sh
cp ./git-prompt.sh ~/.sh

if [[ -f ./.osx && `uname` == "Darwin" ]]; then
	echo "Updating OSX settings and installing brew apps"
	source ./.brew
	source ./.osx
fi