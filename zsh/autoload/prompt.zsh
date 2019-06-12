# Enable color
autoload -Uz colors && colors

# Set left prompt format yourself
#   * Using set color from Zsh's colors function
PROMPT="${fg[cyan]}%n${reset_color} at "          # Username
PROMPT+="${fg[yellow]}%m${reset_color} in "       # Hostname
PROMPT+="${fg[green]}%2d${reset_color} "          # Directory
PROMPT+="%1(v|on ${fg[blue]}%1v${reset_color}|) " # VCS branch
PROMPT+="%2(v|${fg[yellow]}%2v${reset_color}|)"   # VCS status
PROMPT+="%3(v|%${fg[red]}%3v${reset_color}|)"     # VCS error messages
PROMPT+='
❯ '

# Set right prompt
RPROMPT=

# If you want to load prompt themes, please enable following line.
#
# Example:
#   prompt adam1 # Load adam1 theme
#
# autoload -Uz promptinit && promptinit


# Eanble `add-zsh-hook`
autoload -Uz add-zsh-hook

# Prepare to show VCS information on prompt
autoload -Uz vcs_info

# Export 3 type messages
#   $vcs_info_msg_0_: Normal
#   $vcs_info_msg_1_: Warning
#   $vcs_info_msg_2_: Error
zstyle ':vcs_info:*' max-exports 3
__show_vcs_info_precmd() {
  vcs_info
  psvar=()
  [[ -n $vcs_info_msg_0_ ]] && psvar[1]=$vcs_info_msg_0_
  [[ -n $vcs_info_msg_1_ ]] && psvar[2]=$vcs_info_msg_1_
  [[ -n $vcs_info_msg_2_ ]] && psvar[3]=$vcs_info_msg_2_
}
add-zsh-hook precmd __show_vcs_info_precmd

# vcs_info defaults
zstyle ':vcs_info:*' enbale git cvs svn bzr hg
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' check-for-staged-changes true

# vcs_info for Git
readonly GIT_STAGED_SYMBOL='⇡'
readonly GIT_UNSTAGED_SYMBOL='⇣'
zstyle ':vcs_info:git:*' stagedstr ${GIT_STAGED_SYMBOL}
zstyle ':vcs_info:git:*' unstagedstr ${GIT_UNSTAGED_SYMBOL}
__define_git_symbol() {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
    return 1
  fi
  GIT_SYMBOL=''
  [[ $(git remote get-url origin | grep github) ]] && GIT_SYMBOL=' '
  [[ $(git remote get-url origin | grep bitbucket) ]] && GIT_SYMBOL=''
  zstyle ':vcs_info:git:*' formats "${GIT_SYMBOL} %b" '%u%c'
  zstyle ':vcs_info:git:*' actionformats "${GIT_SYMBOL} %b" '%u%c %m' '<!%a>'
}
add-zsh-hook chpwd __define_git_symbol
