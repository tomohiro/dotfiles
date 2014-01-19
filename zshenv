# vim: ft=zsh

export KERNEL=$(uname)

## Load path settings

    PATH=/usr/local/bin:/usr/local/sbin:$PATH

    if [ $KERNEL = Darwin ]; then
        [ -d /opt/X11/bin ] && PATH=/opt/X11/bin:$PATH
        [ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
    fi


## Default environment settings

    export SHELL=zsh
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

    if [[ -d $HOME/.rbenv/bin ]]; then # Ubuntu
        PATH=$HOME/.rbenv/bin:$PATH
        eval "$(rbenv init -)"
        source $HOME/.rbenv/completions/rbenv.zsh
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


### for WebMagic development

    export WEBMAGIC_SRC_PATH=$HOME/Boxes/webmagic-boxes/vagrant/webmagic-dev-box/webmagic


### For PostgreSQL

    if [ -d /Applications/Postgres93.app/Contents/MacOS/bin ]; then
        PATH="$PATH:/Applications/Postgres93.app/Contents/MacOS/bin"
    fi

### For Glassfish

    if [ -d /usr/local/opt/glassfish ]; then
        export GLASSFISH_HOME=/usr/local/opt/glassfish/libexec
        PATH=${PATH}:${GLASSFISH_HOME}/bin
    fi


### For Packer

    export PACKER_CACHE_DIR=$HOME/Boxes/packer_cache


## Load local environment

    LOCALENV=$HOME/.private/etc/zshrc
    if [ -f $LOCALENV ]; then
        source $LOCALENV
    fi
