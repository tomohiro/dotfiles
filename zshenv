# vim: ft=zsh

if [ -f $HOME/.proxy ]; then
  source $HOME/.proxy
fi

export KERNEL=$(uname)

## Load path settings

    PATH=/usr/local/bin:/usr/local/sbin:$PATH

    if [ $KERNEL = Darwin ]; then
        [ -d /opt/X11/bin ] && PATH=/opt/X11/bin:$PATH
        [ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
    fi

# Starting keychain

    KEYCHAIN=`which keychain`
    if [ $? = 0 ]; then
        HOST=`hostname`
        IDENTITY=~/.ssh/id_rsa
        SSH_AGENT=~/.keychain/$HOST-sh
        $KEYCHAIN $IDENTITY
        . $SSH_AGENT
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
    export TERM_256=screen-256color
    export TERM=$TERM_256
    export LS_COLORS='di=01;36'


### for `Bundlizer`

    if [[ -d $HOME/.bundlizer ]]; then
        source $HOME/.bundlizer/etc/bashrc
        source $HOME/.bundlizer/completions/bundlizer.zsh
    fi


### for Ruby `rbenv`

    if type rbenv &> /dev/null; then
        eval "$(rbenv init -)"
    fi


### for PHP `phpenv`

    if [[ -d $HOME/.phpenv/bin ]]; then
        PATH=$HOME/.phpenv/bin:$PATH
        eval "$(phpenv init -)"
        source $HOME/.phpenv/completions/phpenv.zsh
    fi


### for Python `pythonbrew`

    if [[ -s $HOME/.pythonbrew/etc/bashrc ]]; then
        source $HOME/.pythonbrew/etc/bashrc
    fi


### for Perl `plenv`

    if [[ -d $HOME/.plenv/bin ]]; then
        export PATH=$HOME/.plenv/bin:$PATH
        eval "$(plenv init -)";
        source $HOME/.plenv/completions/plenv.zsh
    elif which plenv > /dev/null; then
        eval "$(plenv init -)";
    fi


### for Node and npm

    if type npm &> /dev/null; then
        export NODE_PATH=/usr/local/lib/node_modules
        export PATH=/usr/local/share/npm/bin:$PATH
    fi


### Export PATH

    export PATH=$HOME/.private/bin:$HOME/bin:$PATH
    typeset -U path cdpath fpath manpath


### For Golang

    if type go &> /dev/null; then
        export GOPATH=$HOME/Workspaces/Repositories
        export PATH=$PATH:$GOPATH/bin
    fi


### for WebMagic development

    if [ -d $GOPATH/src/github.com/occ-corp/webmagic  ]; then
        export WEBMAGIC_SRC_PATH=$GOPATH/src/github.com/occ-corp/webmagic
    fi


### For PostgreSQL

    if [ -d /Applications/Postgres93.app/Contents/MacOS/bin ]; then
        PATH="$PATH:/Applications/Postgres93.app/Contents/MacOS/bin"
    fi


### For Glassfish

    if [ -d /usr/local/opt/glassfish ]; then
        export GLASSFISH_HOME=/usr/local/opt/glassfish/libexec
        PATH=${PATH}:${GLASSFISH_HOME}/bin
    fi


### For Docker

    if type docker &> /dev/null; then
        export DOCKER_HOST=tcp://localhost:4243
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
