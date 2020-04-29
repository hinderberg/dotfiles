#!/usr/bin/env bash

cp ./.gitconfig ~/.gitconfig
cp ./.gitignore ~/.gitignore
cp ./.gitignore_global ~/.gitignore_global
cp ./.profile ~/.profile
cp ./.npmrc ~/.npmrc
cp ./.zshrc ~/.zshrc

if [[ `uname` == "Darwin" ]]; then
	echo "Updating OSX settings and installing apps"
	xcode-select --install
	sh ./.programs
fi

echo "Finished"