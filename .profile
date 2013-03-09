####################
# Alias
####################

# Default

alias ls="ls -G -F"
alias la="ls -al"
alias ll="ls -l"
alias l="ls"

alias pu="pushd ."
alias po="popd"

alias ..="cd ../.."
alias ...="cd ../../.."
alias ....="cd ../../../.."
alias h="cd ~"

# Code-convenience

alias mci='mvn clean install'
alias mcit='mvn clean install -Dmaven.test.skip'
alias mt='mvn test'
alias startmysql='/usr/local/Cellar/mysql/5.1.47/share/mysql/mysql.server start'
alias stopmysql='/usr/local/Cellar/mysql/5.1.47/share/mysql/mysql.server stop'

# Folders

alias dev='cd ~/Dropbox/Utvikling'

# OSX

alias s='open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app'
alias safarihardware='CA_COLOR_OPAQUE=1 /Applications/Safari.app/Contents/MacOS/Safari'
alias simulatorhardware='CA_COLOR_OPAQUE=1 /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone\ Simulator.app/Contents/MacOS/iPhone\ Simulator'
alias ios="open /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone\ Simulator.app"

####################
# Exports
####################

export PATH=$PATH:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/share/npm/bin:/usr/bin::/Users/hinderberg/Documents/Github/depot_tools

# Node

export NODE_PATH="/usr/local/lib/node"

# Heroku

export PATH="/usr/local/heroku/bin:$PATH"

#Android

export ANDROID_SDK=/usr/local/Cellar/android-sdk/r20.0.1

####################
# Functions
####################

function _useJava() {
	export JAVA_HOME=$(/usr/libexec/java_home -v ${1} -d64)
}

_useJava 1.7

function server() {
	python -m SimpleHTTPServer $1
}

function command_not_found_handle() {
	appname=${1//_/-}
	appname=${appname//-/[-_\ ]} 
	echo "Searching Mac app that matches $appname.app ..."
	app=`find /Applications -name "*.app" -prune | grep -i -m1 "/$appname.app"`

	if [ "$app" != "" ]
	then
		shift 1
		file=$1
		shift 1
		if [ "$file" == "" ]
		then
			echo "Launching $app ..."
                	open -a "$app"
		else
			if [ "$1" == "" ]
			then
				echo "Launching $app on $file ..."
				open -a "$app" "$file"
			else
				echo "Launching $app on $file with parameters $@ ..."
				open -a "$app" "$file" --args "$@"
			fi
		fi
		return 0
	fi

	echo $"$1: command not found"
	return 127
}

if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function