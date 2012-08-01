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


    # DEFAULT_PROMPT="$fg[red][%n@%m]$fg[blue][%d]%1(v|$fg[green]%1v%f|)$fg[yellow]
# » %F{white}"
    DEFAULT_PROMPT="%F{cyan}%n%F{white} at %F{magenta}%m%F{white} in %F{blue}%d%F{white} %1(v|on %F{red}%v|)
%F{yellow}» %F{grey}"
    PROMPT=$DEFAULT_PROMPT


### precmd

    precmd() {
        # VCS info
        psvar=()
        LANG=en_US.UTF-8 vcs_info
        [[ -n $vcs_info_msg_0_ ]] && psvar[1]="$vcs_info_msg_0_"

        # Check Ruby version and gemset at RVM
        #if [[ -f Gemfile || -f .rvmrc ]]; then
        #    RPROMPT="%F{red}[`rvm current`]%F{white}"
        #else
        #   RPROMPT=""
        #fi
    }


### if change directory

    chpwd() {
        _reg_pwd_screennum
        ls
    }
