### Loading modules

    autoload -U promptinit
    promptinit

    autoload -Uz vcs_info
    zstyle ':vcs_info:*' enbale git cvs svn bzr hg
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' check-for-staged-changes true
    zstyle ':vcs_info:git:*' stagedstr "!"
    zstyle ':vcs_info:git:*' unstagedstr "+"
    zstyle ':vcs_info:git:*' formats '%b [%c%u]'
    zstyle ':vcs_info:git:*' actionformats '(%s)-[%r/%b|%a]'
    zstyle ':vcs_info:svn:*' branchformat '%b (current revision is %r)'

    autoload -U colors
    colors


### Set default prompt

    PROMPT_FORMAT="%F{cyan}%n%f at %F{yellow}%m%f in %F{blue}%d%f %1(v|on %F{red}%v|)
%F{magenta}❯%f "
    PROMPT=$PROMPT_FORMAT


### precmd

    precmd() {
        psvar=()
        vcs_info
        [[ -n $vcs_info_msg_0_ ]] && psvar[1]=$vcs_info_msg_0_
    }


### if change directory

    chpwd() {
        _cdd_chpwd
        ls
    }
