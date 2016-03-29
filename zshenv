# vim: ft=zsh

if [ -f $HOME/.proxy ]; then
  source $HOME/.proxy
fi


## Load path settings

    # Disable loading global profiles for OS X El Capitan.
    #   - http://mattprice.me/2015/zsh-path-issues-osx-el-capitan/
    setopt no_global_rcs
    PATH=/usr/local/bin:/usr/local/sbin:$PATH
    [ -d /opt/X11/bin ] && PATH=/opt/X11/bin:$PATH


### for `Bundlizer`

    if [[ -d $HOME/.bundlizer ]]; then
        source $HOME/.bundlizer/etc/bashrc
        source $HOME/.bundlizer/completions/bundlizer.zsh
    fi

    if [ -f /opt/boxen/env.sh ]; then
        source /opt/boxen/env.sh
    else
        if type rbenv &> /dev/null; then
            eval "$(rbenv init -)"
        fi

        if type pyenv &> /dev/null; then
            export PYENV_ROOT=/usr/local/var/pyenv
            eval "$(pyenv init -)"
        fi

        if type nodenv &> /dev/null; then
            eval "$(nodenv init -)"
        fi

        if type plenv &> /dev/null; then
            eval "$(plenv init -)"
        fi
    fi


### For Golang

    if type go &> /dev/null; then
        export GOPATH=$HOME/Workspaces/Repositories
        export GOROOT=$(go env GOROOT)
        export CGO_CFLAGS=$CFLAGS
        export CGO_LDFLAGS=$LDFLAGS
        export PATH=$PATH:$GOPATH/bin
    fi


### For Xcode

    XCODE_PATH=/Applications/Xcode.app
    if [ -d $XCODE_PATH ]; then
        PATH=${PATH}:${XCODE_PATH}/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin
    fi

### For Rust/Cargo

    if [ -d $HOME/.cargo ]; then
        PATH=${PATH}:${HOME}/.cargo/bin
    fi


### For Java

    JAVA_HOME=$(/usr/libexec/java_home)

    # GlassFish
    if [ -d /usr/local/opt/glassfish ]; then
        export GLASSFISH_HOME=/usr/local/opt/glassfish/libexec
        PATH=${PATH}:${GLASSFISH_HOME}/bin
    fi


## Default environment settings

    export SHELL=$(which zsh)
    export LANG=en_US.UTF-8
    export LC_ALL=$LANG
    export EDITOR=$(which vim)
    export SVN_EDITOR=$EDITOR
    export PAGER=lv
    export LISTMAX=10000
    export TERM_256=xterm-256color
    export TERM=$TERM_256
    export LS_COLORS='di=01;36'


### Export PATH

    export PATH=$HOME/.private/bin:$HOME/bin:$PATH
    typeset -U path cdpath fpath manpath


## Load local environment

    LOCALENV=$HOME/.private/etc/zshrc
    if [ -f $LOCALENV ]; then
        source $LOCALENV
    fi

### For Docker

    if type docker &> /dev/null; then
        # coreos-xhyve IP address and port
        export DOCKER_HOST=tcp://192.168.64.2:2375
    fi


### For Packer

    if type packer &> /dev/null; then
        export PACKER_CACHE_DIR=$HOME/Workspaces/Images
    fi


## Load Direnv

    if type direnv &> /dev/null; then
        eval "$(direnv hook zsh)"
    fi


# Starting keychain

    if type keychain &> /dev/null; then
        HOST=$(hostname)
        SSH_AGENT=$HOME/.keychain/$HOST-sh
        keychain -q $HOME/.ssh/id_rsa
        source $SSH_AGENT
    fi
