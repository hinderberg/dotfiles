#!/usr/bin/env bash
if [[ `uname` == "Darwin" ]]; then
	cp ./.gitconfig ~/.gitconfig
	cp ./.npmrc ~/.npmrc
	cp ./.zshrc ~/.zshrc

	mkdir -p ~/.1password && ln -s ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ~/.1password/agent.sock
	cp -R ./.ssh ~/.ssh

	mkdir -p ~/coding-personal
	cp ./.gitconfig.personal ~/coding-personal/.gitconfig
	mkdir -p ~/coding-work/.gitconfig.work
	cp ./.gitconfig.work ~/coding-work/.gitconfig

	echo "Updating OSX settings and installing apps"
	xcode-select --install
	sh ./programs

	echo "Finished"
else
	echo "Not OSX"
fi
