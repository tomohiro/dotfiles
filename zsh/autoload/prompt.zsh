# Enable color
autoload -Uz colors && colors

# If you want to load prompt themes, please enable following line.
#
# Example:
#   prompt adam1 # Load adam1 theme
#
# autoload -Uz promptinit && promptinit

# Set left prompt format yourself
PROMPT="%F{cyan}%n%f at %F{yellow}%m%f in %F{blue}%2d%f %1(v|on %F{magenta}%1v%f|) %2(v|%F{yellow}%2v%f|)%3(v|%F{red}%3v%f|)
%F{green}❯%f "

# Set right prompt
RPROMPT=

# Eanble `add-zsh-hook`
autoload -Uz add-zsh-hook

# Prepare to show VCS information on prompt
autoload -Uz vcs_info

# Export 3 type messages
#   $vcs_info_msg_0: Normal
#   $vcs_info_msg_1: Warning
#   $vcs_info_msg_2: Error
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
GIT_SYMBOL='' # or \uf408(  )
GIT_STAGED_SYMBOL='⇡'
GIT_UNSTAGED_SYMBOL='⇣'
zstyle ':vcs_info:git:*' stagedstr ${GIT_STAGED_SYMBOL}
zstyle ':vcs_info:git:*' unstagedstr ${GIT_UNSTAGED_SYMBOL}
zstyle ':vcs_info:git:*' formats "${GIT_SYMBOL} %b" '%u%c'
zstyle ':vcs_info:git:*' actionformats "${GIT_SYMBOL} %b" '%u%c %m' '<!%a>'
