####################
# Alias
####################

# Default

alias ls="ls -G -F"
alias la="ls -al"
alias ll="ls -l"
alias l="ls"

alias sortc="pbpaste | sort | pbcopy"

alias pu="pushd ."
alias po="popd"

alias ..="cd ../.."
alias ...="cd ../../.."
alias ....="cd ../../../.."
alias h="cd ~"

alias o="open"
alias oo="open ."
alias h="history"

alias d="cd ~/Dropbox"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias dev="cd ~/Dropbox/Dev"

# Code-convenience

alias mci='mvn clean install'
alias mcit='mvn clean install -Dmaven.test.skip'
alias mt='mvn test'

alias g="git"

####################
# Exports
####################
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/share/npm/bin:/usr/bin:$PATH

# Node

export NODE_PATH="/usr/local/lib/node"

# Heroku

export PATH="/usr/local/heroku/bin:$PATH"

# History

shopt -s cmdhist
export HISTCONTROL=erasedups
export HISTFILESIZE=10000
export HISTIGNORE="&:ls:cd:[bf]g:exit:..:...:l:ll:la:pu:po:unrar:exit"
export HISTSIZE=10000

# Language

export NLS_LANG=NORWEGIAN_NORWAY.UTF8
export LANG="en_US"
export LC_ALL="en_US.UTF-8"

# Grep

GREP_OPTIONS='--color=auto'
GREP_COLORS='ms=1;31'
export GREP_OPTIONS GREP_COLORS

# Man

MANWIDTH=80
export MANWIDTH

# Mail

unset MAILCHECK

# Docker

function useDocker() {
	eval "$(docker-machine env dev)"
}

####################
# Functions
####################

function _useJava() {
	export JAVA_HOME=$(/usr/libexec/java_home -v ${1} -d64)
}

_useJava 1.8

function server() {
	python -m SimpleHTTPServer $1
}

export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin
export ANDROID_HOME=/usr/local/opt/android-sdk
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/tools:$PATH


export PATH=$PATH:$HOME/Library/Python/2.7/bin
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. $HOME/Library/Python/2.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh


 [ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion