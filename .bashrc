####################
# Expors
####################

# PS1

##-ANSI-COLOR-CODES-##
Color_Off="\[\033[0m\]"
###-Regular-###
Red="\[\033[0;31m\]"
Green="\[\033[0;32m\]"
Purple="\[\033[0;35\]"
####-Bold-####
BRed="\[\033[1;31m\]"
BPurple="\[\033[1;35m\]"

#Attribute codes:
#00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed 

#Text color codes:
#30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white

#Background color codes:
#40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white

# Set the terminal title to the current working directory


# Build the prompt
# set up command prompt
function __prompt_command()
{
    # capture the exit status of the last command
    EXIT="$?"
    PS1="\[\033]0;\w\007\]"
 
    if [ $EXIT -eq 0 ]; then PS1+="\[$Green\][\!]\[$Color_Off\] "; else PS1+="\[$Red\][\!]\[$Color_Off\] "; fi
 
    # if logged in via ssh shows the ip of the client
    if [ -n "$SSH_CLIENT" ]; then PS1+="\[$Yellow\]("${$SSH_CLIENT%% *}")\[$Color_Off\]"; fi
 
    # debian chroot stuff (take it or leave it)
    PS1+="${debian_chroot:+($debian_chroot)}"
 
    # basic information (user@host:path)
    PS1+="\[$BRed\]\[$BRed\]\h\[$Color_Off\]:\[$BPurple\]\w\[$Color_Off\] "
 
    # check if inside git repo
    local git_status="`git status -unormal 2>&1`"    
    if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
        # parse the porcelain output of git status
        if [[ "$git_status" =~ nothing\ to\ commit ]]; then
            local Color_On=$Green
        elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
            local Color_On=$Purple
        else
            local Color_On=$Red
        fi
 
        if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]; then
            branch=${BASH_REMATCH[1]}
        else
            # Detached HEAD. (branch=HEAD is a faster alternative.)
            branch="(`git describe --all --contains --abbrev=4 HEAD 2> /dev/null || echo HEAD`)"
        fi
 
        # add the result to prompt
        PS1+="\[$Color_On\][$branch]\[$Color_Off\] "
    fi
 
    # prompt $ or # for root
    PS1+="\$ "
}

PROMPT_COMMAND=__prompt_command
