#!/usr/bin/env bash

cp ./.gitconfig ~/.gitconfig
cp ./.npmrc ~/.npmrc
cp ./.zshrc ~/.zshrc
cp -R ./.hammerspoon ~/.hammerspoon

if [[ `uname` == "Darwin" ]]; then
	echo "Updating OSX settings and installing apps"
	xcode-select --install
	sh ./.programs
fi

echo "Finished"