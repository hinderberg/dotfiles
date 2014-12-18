# Only for bash:
[ "$BASH_VERSION" ] || return

PROMPT_DIRTRIM=3

if tput setaf 1 &> /dev/null; then
  tput sgr0 &> /dev/null

  # If you would like to customize your colors, use
  # # Attribution: http://linuxtidbits.wordpress.com/2008/08/11/output-color-on-bash-scripts/
  # for i in $(seq 0 $(tput colors)); do
  #   echo " $(tput setaf $i)Text$(tput sgr0) $(tput bold)$(tput setaf $i)Text$(tput sgr0) $(tput sgr 0 1)$(tput setaf $i)Text$(tput sgr0)  \$(tput setaf $i)"
  # done

  # Save common color actions
  bold="$(tput bold)"
  reset="$(tput sgr0)"

  # If the terminal supports at least 256 colors, write out our 256 color based set
  if [[ "$(tput colors)" -ge 256 ]] &> /dev/null; then
    user_color="$bold$(tput setaf 27)" # BOLD BLUE
    preposition_color="$bold$(tput setaf 7)" # BOLD WHITE
    device_color="$bold$(tput setaf 39)" # BOLD CYAN
    dir_color="$bold$(tput setaf 76)" # BOLD GREEN
    git_status_color="$bold$(tput setaf 154)" # BOLD YELLOW
    git_progress_color="$bold$(tput setaf 9)" # BOLD RED
  else
    # Otherwise, use colors from our set of 8
    user_color="$bold$(tput setaf 4)" # BOLD BLUE
    preposition_color="$bold$(tput setaf 7)" # BOLD WHITE
    device_color="$bold$(tput setaf 6)" # BOLD CYAN
    dir_color="$bold$(tput setaf 2)" # BOLD GREEN
    git_status_color="$bold$(tput setaf 3)" # BOLD YELLOW
    git_progress_color="$bold$(tput setaf 1)" # BOLD RED
  fi

  symbol_color="$bold" # BOLD

else
  # Otherwise, use ANSI escape sequences for coloring
  # If you would like to customize your colors, use
  # DEV: 30-39 lines up 0-9 from `tput`
  # for i in $(seq 0 109); do
  #   echo -n -e "\033[1;${i}mText$(tput sgr0) "
  #   echo "\033[1;${i}m"
  # done

  reset="\033[m"
  user_color="\033[1;34m" # BLUE
  preposition_color="\033[1;37m" # WHITE
  device_color="\033[1;36m" # CYAN
  dir_color="\033[1;32m" # GREEN
  git_status_color="\033[1;33m" # YELLOW
  git_progress_color="\033[1;31m" # RED
  symbol_color="" # NORMAL
fi

# Apply any color overrides that have been set in the environment
[ "$PROMPT_USER_COLOR" ] && user_color="$PROMPT_USER_COLOR"
[ "$PROMPT_PREPOSITION_COLOR" ] && preposition_color="$PROMPT_PREPOSITION_COLOR"
[ "$PROMPT_DEVICE_COLOR" ] && device_color="$PROMPT_DEVICE_COLOR"
[ "$PROMPT_DIR_COLOR" ] && dir_color="$PROMPT_DIR_COLOR"
[ "$PROMPT_GIT_STATUS_COLOR" ] && git_status_color="$PROMPT_GIT_STATUS_COLOR"
[ "$PROMPT_GIT_PROGRESS_COLOR" ] && git_progress_color="$PROMPT_GIT_PROGRESS_COLOR"
[ "$PROMPT_SYMBOL_COLOR" ] && symbol_color="$PROMPT_SYMBOL_COLOR"

# Set up symbols
synced_symbol=""
dirty_synced_symbol="*"
unpushed_symbol="△ "
dirty_unpushed_symbol="▲ "
unpulled_symbol="▽ "
dirty_unpulled_symbol="▼ "
unpushed_unpulled_symbol="⬡ "
dirty_unpushed_unpulled_symbol="⬢ "

# Apply symbol overrides that have been set in the environment
# DEV: Working unicode symbols can be determined via the following gist
#   **WARNING: The following gist has 64k lines and may freeze your browser**
#   https://gist.github.com/twolfson/9cc7968eb6ee8b9ad877
[ "$PROMPT_SYNCED_SYMBOL" ] && synced_symbol="$PROMPT_SYNCED_SYMBOL"
[ "$PROMPT_DIRTY_SYNCED_SYMBOL" ] && dirty_synced_symbol="$PROMPT_DIRTY_SYNCED_SYMBOL"
[ "$PROMPT_UNPUSHED_SYMBOL" ] && unpushed_symbol="$PROMPT_UNPUSHED_SYMBOL"
[ "$PROMPT_DIRTY_UNPUSHED_SYMBOL" ] && dirty_unpushed_symbol="$PROMPT_DIRTY_UNPUSHED_SYMBOL"
[ "$PROMPT_UNPULLED_SYMBOL" ] && unpulled_symbol="$PROMPT_UNPULLED_SYMBOL"
[ "$PROMPT_DIRTY_UNPULLED_SYMBOL" ] && dirty_unpulled_symbol="$PROMPT_DIRTY_UNPULLED_SYMBOL"
[ "$PROMPT_UNPUSHED_UNPULLED_SYMBOL" ] && unpushed_unpulled_symbol="$PROMPT_UNPUSHED_UNPULLED_SYMBOL"
[ "$PROMPT_DIRTY_UNPUSHED_UNPULLED_SYMBOL" ] && dirty_unpushed_unpulled_symbol="$PROMPT_DIRTY_UNPUSHED_UNPULLED_SYMBOL"

get_git_branch() {
  # On branches, this will return the branch name
  # On non-branches, (no branch)
  local ref="$(git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///')"
  if [ "$ref" ]; then
    echo "$ref"
  else
    echo "(no branch)"
  fi
}

get_git_progress() {
  # Detect in-progress actions (e.g. merge, rebase)
  # https://github.com/git/git/blob/v1.9-rc2/wt-status.c#L1199-L1241
  local git_dir="$(git rev-parse --git-dir)"

  # git merge
  if [[ -f "$git_dir/MERGE_HEAD" ]]; then
    echo " [merge]"
  elif [[ -d "$git_dir/rebase-apply" ]]; then
    # git am
    if [[ -f "$git_dir/rebase-apply/applying" ]]; then
      echo " [am]"
      # git rebase
    else
      echo " [rebase]"
    fi
  elif [[ -d "$git_dir/rebase-merge" ]]; then
    # git rebase --interactive/--merge
    echo " [rebase]"
  elif [[ -f "$git_dir/CHERRY_PICK_HEAD" ]]; then
    # git cherry-pick
    echo " [cherry-pick]"
  fi
  if [[ -f "$git_dir/BISECT_LOG" ]]; then
    # git bisect
    echo " [bisect]"
  fi
  if [[ -f "$git_dir/REVERT_HEAD" ]]; then
    # git revert --no-commit
    echo " [revert]"
  fi
}

is_branch1_behind_branch2() {
  # $ git log origin/master..master -1
  # commit 4a633f715caf26f6e9495198f89bba20f3402a32
  # Author: Todd Wolfson <todd@twolfson.com>
  # Date:   Sun Jul 7 22:12:17 2013 -0700
  #
  #     Unsynced commit

  # Find the first log (if any) that is in branch1 but not branch2
  local first_log="$(git log $1..$2 -1 2> /dev/null)"

  # Exit with 0 if there is a first log, 1 if there is not
  [ "$first_log" ]
}

branch_exists() {
  # List remote branches           | # Find our branch and exit with 0 or 1 if found/not found
  git branch --remote 2> /dev/null | grep --quiet "$1"
}

parse_git_ahead() {
  # Grab the local and remote branch
  local branch="$(get_git_branch)"
  local remote_branch="origin/$branch"

  # $ git log origin/master..master
  # commit 4a633f715caf26f6e9495198f89bba20f3402a32
  # Author: Todd Wolfson <todd@twolfson.com>
  # Date:   Sun Jul 7 22:12:17 2013 -0700
  #
  #     Unsynced commit

  # If the remote branch is behind the local branch
  # or it has not been merged into origin (remote branch doesn't exist)
  if is_branch1_behind_branch2 "$remote_branch" "$branch" ||
    ! branch_exists "$remote_branch"; then
    # echo our character
    echo 1
  fi
}

parse_git_behind() {
  # Grab the branch
  local branch="$(get_git_branch)"
  local remote_branch="origin/$branch"

  # $ git log master..origin/master
  # commit 4a633f715caf26f6e9495198f89bba20f3402a32
  # Author: Todd Wolfson <todd@twolfson.com>
  # Date:   Sun Jul 7 22:12:17 2013 -0700
  #
  #     Unsynced commit

  # If the local branch is behind the remote branch
  if is_branch1_behind_branch2 "$branch" "$remote_branch"; then
    # echo our character
    echo 1
  fi
}

parse_git_dirty() {
  # If the git status has *any* changes (e.g. dirty), echo our character
  if [ "$(git status --porcelain 2> /dev/null)" ]; then
    echo 1
  fi
}

get_git_status() {
  # Grab the git dirty and git behind
  local dirty_branch="$(parse_git_dirty)"
  local branch_ahead="$(parse_git_ahead)"
  local branch_behind="$(parse_git_behind)"

  # Iterate through all the cases and if it matches, then echo
  if [[ "$dirty_branch" == 1 && "$branch_ahead" == 1 && "$branch_behind" == 1 ]]; then
    echo "$dirty_unpushed_unpulled_symbol"
  elif [[ "$branch_ahead" == 1 && "$branch_behind" == 1 ]]; then
    echo "$unpushed_unpulled_symbol"
  elif [[ "$dirty_branch" == 1 && "$branch_ahead" == 1 ]]; then
    echo "$dirty_unpushed_symbol"
  elif [[ "$branch_ahead" == 1 ]]; then
    echo "$unpushed_symbol"
  elif [[ "$dirty_branch" == 1 && "$branch_behind" == 1 ]]; then
    echo "$dirty_unpulled_symbol"
  elif [[ "$branch_behind" == 1 ]]; then
    echo "$unpulled_symbol"
  elif [[ "$dirty_branch" == 1 ]]; then
    echo "$dirty_synced_symbol"
  else # clean
    echo "$synced_symbol"
  fi
}

get_git_info() {
  # Grab the branch
  local branch="$(get_git_branch)"

  # If there are any branches
  if [ "$branch" ]; then
    # The branch and git status
    echo "$branch $(get_git_status)"
  fi
}

is_on_git() {
  git rev-parse 2> /dev/null
}

ssh_client() {
  if [ "$SSH_CLIENT" ]; then
    echo "(${$SSH_CLIENT%% *})";
  fi
}

create_bash_prompt() {
  PS1="\[$user_color\]$(ssh_client)\[$reset\]\[$dir_color\]\w\[$reset\]\$( is_on_git && echo -n \" \[$preposition_color\] on \[$reset\] \" && echo -n \"\[$git_status_color\]\$(get_git_info)\" && echo -n \"\[$git_progress_color\]\$(get_git_progress)\" && echo -n \"\[$preposition_color\]\")\[$reset\]\[$symbol_color\] \$ \[$reset\]"
}

set_tab_title() {
  echo -n -e "\033]0;${PWD##*/}\007"
}

export PROMPT_COMMAND=create_bash_prompt
export PROMPT_COMMAND="set_tab_title ; $PROMPT_COMMAND"
