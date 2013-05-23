####################
# Expors
####################

# Terminal Title

set_terminal_title() {
    if [[ -z $@ ]]
    then
        TERMINAL_TITLE=$PWD
    else
        TERMINAL_TITLE=$@
    fi
}

alias stt='set_terminal_title'

# PS1

#Attribute codes:
#00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed 

#Text color codes:
#30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white

#Background color codes:
#40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white

# - colors
C_RED='\e[00:31m'
C_GREEN='\e[00:32m'
C_BLUE='\e[00;36m'
C_CYAN='\e[00;34m'
C_MAGENTA='\e[00;35m'
C_YELLOW='\e[00;33m'
C_RESET='\e[00:0m'

C_B_RED='\e[01:31m'
C_B_GREEN='\e[01:32m'
C_B_MAGENTA='\e[01;35m'
C_B_YELLOW='\e[01;33m'
C_B_WHITE='\e[1;37m' 

# - git

GIT_PROMPT_PREFIX="${C_GREEN}[${C_RESET}"
GIT_PROMPT_SUFFIX="${C_GREEN}]${C_RESET}"
GIT_PROMPT_AHEAD="${C_RED}ANUM${C_RESET}"
GIT_PROMPT_BEHIND="${C_CYAN}BNUM${C_RESET}"
GIT_PROMPT_MERGING="${C_B_MAGENTA}merging${C_RESET}"
GIT_PROMPT_UNTRACKED="${C_B_RED}u${C_RESET}"
GIT_PROMPT_MODIFIED="${C_B_YELLOW}m${C_RESET}"
GIT_PROMPT_STAGED="${C_B_GREEN}s${C_RESET}"
 
parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
 
parse_git_state() {
	local GIT_STATE=""

	local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
	if [ "$NUM_AHEAD" -gt 0 ]; then
		GIT_STATE"$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}"
	fi

	local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
	if [ "$NUM_BEHIND" -gt 0 ]; then
		GIT_STATE="$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}"
	fi

	local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
	if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
		GIT_STATE="$GIT_STATE$GIT_PROMPT_MERGING"
	fi

	if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
		GIT_STATE="$GIT_STATE$GIT_PROMPT_UNTRACKED"
	fi

	if ! git diff --quiet 2> /dev/null; then
		GIT_STATE="$GIT_STATE$GIT_PROMPT_MODIFIED"
	fi

	if ! git diff --cached --quiet 2> /dev/null; then
		GIT_STATE="$GIT_STATE$GIT_PROMPT_STAGED"
	fi

	if [[ -n $GIT_STATE ]]; then
		echo -e "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
	fi
}
 
git_prompt_string() {
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo -e "$(parse_git_state)$GIT_PROMPT_PREFIX${C_YELLOW}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX"
}

# Use unicode prompt symbol in when:
#   - running with UTF-8 locale and
#   - not in real console where fonts are limited to ASCII
if tty | grep -F /dev/pts >/dev/null && [[ $LANG == *UTF-8* ]]; then
  prompt_symbol='❯'
else
  prompt_symbol='>'
fi

# Color prompt symbol red when last command had a non-zero exit code:
_ok_status() {
  [ $1 -eq 0 -o $1 -eq 130 ]
}

PS1=''
PS1="$PS1\[${C_B_WHITE}\]"'\w '
PS1="$PS1\[${C_GREEN}\]"'$(git_prompt_string)'"\[${C_RESET}\]"
PS1="$PS1"'$(_ok_status $? && printf "'${C_GREY}'" || printf "'${C_RED}'")'
PS1="${PS1} ${prompt_symbol}\[${C_RESET}\] "

PS2="\[${C_BLUE}\]${prompt_symbol}\[${C_RESET}\] "

unset prompt_symbol
