# vim: ft=zsh

if [ -f $HOME/.proxy ]; then
  source $HOME/.proxy
fi

export KERNEL=$(uname)

## Load path settings

    PATH=/usr/local/bin:/usr/local/sbin:$PATH

    [ -d /opt/X11/bin ] && PATH=/opt/X11/bin:$PATH
    [ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh


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


# Starting keychain

    if type keychain &> /dev/null; then
        HOST=$(hostname)
        SSH_AGENT=$HOME/.keychain/$HOST-sh
        keychain $HOME/.ssh/id_rsa
        source $SSH_AGENT
    fi


### for `Bundlizer`

    if [[ -d $HOME/.bundlizer ]]; then
        source $HOME/.bundlizer/etc/bashrc
        source $HOME/.bundlizer/completions/bundlizer.zsh
    fi


### for Ruby `rbenv`

    if type rbenv &> /dev/null; then
        eval "$(rbenv init -)"
    fi


### for Perl `plenv`

    if type plenv &> /dev/null; then
        eval "$(plenv init -)"
    fi


### Export PATH

    export PATH=$HOME/.private/bin:$HOME/bin:$PATH
    typeset -U path cdpath fpath manpath


### For Golang

    if type go &> /dev/null; then
        export GOPATH=$HOME/Workspaces/Repositories
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


### For Docker

    if type docker &> /dev/null; then
        export DOCKER_HOST=tcp://172.17.8.101:2375
    fi


### For Packer

    if type packer &> /dev/null; then
        export PACKER_CACHE_DIR=$HOME/Workspaces/Images
    fi

## Load local environment

    LOCALENV=$HOME/.private/etc/zshrc
    if [ -f $LOCALENV ]; then
        source $LOCALENV
    fi

## Load direnv

    eval "$(direnv hook zsh)"
