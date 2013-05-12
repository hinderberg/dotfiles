####################
# Expors
####################

# PS1

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(git::\1)/'  
}
parse_svn_branch() {
  parse_svn_url | sed -e 's#^'"$(parse_svn_repository_root)"'##g' | awk -F / '{print "(svn::"$2 ")"}'
}
parse_svn_url() {
  svn info 2>/dev/null | grep -e '^URL*' | sed -e 's#^URL: *\(.*\)#\1#g '
}
parse_svn_repository_root() {
  svn info 2>/dev/null | grep -e '^Repository Root:*' | sed -e 's#^Repository Root: *\(.*\)#\1\/#g '
}

export PS1='\e[1;34m\]\w \[\e[0;32m\]$(parse_git_branch)$(parse_svn_branch) \[\e[0;0m\]➔\[\e[0;0m\]  '

# Language

export NLS_LANG=NORWEGIAN_NORWAY.UTF8
