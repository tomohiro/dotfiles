# vim: ft=zsh

### Loading modules

    autoload -U promptinit
    promptinit

    autoload -Uz vcs_info
    zstyle ':vcs_info:*' enbale git cvs svn bzr hg
    zstyle ':vcs_info:*' formats '%b'
    zstyle ':vcs_info:*' actionformats '(%s)-[%r/%b|%a]'
    zstyle ':vcs_info:*' branchformat '%b (current revision is %r)'

    autoload -U colors
    colors


### set default prompt

    PROMPT_FORMAT="%F{cyan}%n%F{white} at %F{yellow}%m%F{white} in %F{blue}%d%F{white} %1(v|on %F{red}%v|)
%(?.%F{magenta}.%F{red})❯%f "
    PROMPT=$PROMPT_FORMAT


### precmd

    precmd() {
        # VCS info
        psvar=()
        LANG=en_US.UTF-8 vcs_info
        [[ -n $vcs_info_msg_0_ ]] && psvar[1]="$vcs_info_msg_0_"
    }


### if change directory

    chpwd() {
        _reg_pwd_screennum
        ls
    }
