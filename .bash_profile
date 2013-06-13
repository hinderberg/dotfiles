if [ -f ~/.profile ]; then
	source ~/.profile 
fi

if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

if [[ -f ~/.osx_always && `uname` == "Darwin" ]]; then
	source ~/.osx_always
fi