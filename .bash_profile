if [ -f ~/.profile ]; then
	source ~/.profile 
fi

if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

if [[ -f ~/.osx && `uname` == "Darwin" ]]; then
	source ~/.osx
fi