# vim: ft=zsh
## Default environment settings

    export SHELL=zsh
    export LANG=ja_JP.UTF-8
    export LC_ALL=$LANG
    export EDITOR=`which vim`
    export SVN_EDITOR=$EDITOR
    export PAGER=lv
    export LISTMAX=10000
    export TERM_256=xterm-256color
    export TERM_256=screen-256color
    export TERM=$TERM_256
    export LS_COLORS='di=01;36'
    export KERNEL=`uname`

## Load path settings

    PATH=/usr/local/bin:/usr/local/sbin:$PATH

    if [ $KERNEL = Darwin ]; then
        PATH=/opt/X11/bin:$PATH
    fi

### for `Bundlizer`

    if [[ -d $HOME/.bundlizer ]]; then
        source $HOME/.bundlizer/etc/bashrc
    fi


### for Ruby `rbenv`

    if [[ -d $HOME/.rbenv/bin ]]; then # Ubuntu
        PATH=$HOME/.rbenv/bin:$PATH
        eval "$(rbenv init -)"
        source $HOME/.rbenv/completions/rbenv.zsh
    elif type rbenv &> /dev/null; then # Homebrew on OSX
        eval "$(rbenv init -)"
        source /usr/local/Cellar/rbenv/0.3.0/completions/rbenv.zsh
    fi

### for PHP `phpenv`

    if [[ -d $HOME/.phpenv/bin ]]; then # Ubuntu
        PATH=$HOME/.phpenv/bin:$PATH
        eval "$(phpenv init -)"
        source $HOME/.phpenv/completions/phpenv.zsh
    fi

### for Python `pythonbrew`

    if [[ -s $HOME/.pythonbrew/etc/bashrc ]]; then
        source $HOME/.pythonbrew/etc/bashrc
    fi


### for Perl `perlbrew`

    if [[ -s $HOME/.perlbrew/perl5/etc/bashrc ]]; then
        source $HOME/.perlbrew/perl5/etc/bashrc;
    fi


### for cpanminus

    if type cpanm &> /dev/null && [ -n $PERLBREW_ROOT ]; then
        export PERL_CPANM_OPT=--local-lib=$PERLBREW_ROOT
        export PERL5LIB=$PERLBREW_ROOT/lib/perl5:$PERL5LIB
    fi


### for Android

    if [ $KERNEL = Darwin -a -d $HOME/Library/android-sdk-x86/tools ]; then
        PATH=$HOME/Library/android-sdk-x86/tools:$PATH
    fi


### for Node and npm

    if type npm &> /dev/null; then
        export NODE_PATH=/usr/local/lib/node
    fi


### for Play! framework

    if [[ -s $HOME/play/play ]]; then
        PATH=$PATH:$HOME/play
    fi


### Export PATH

    export PATH=$HOME/.private/bin:$HOME/bin:$PATH
    typeset -U path cdpath fpath manpath


## Set Database settings

### For Oracle

    #export LD_LIBRARY_PATH=/usr/lib/oracle/10.2.0.1/client/lib
    #export NLS_LANG=Japanese_Japan.JA16SJIS
    #export NLS_TIMESTAMP_FORMAT="YYYY-MM-DD HH24:MI:SS"


### For DB2

    #export DB2CODEPAGE=943


### For PostgreSQL

    if [ $KERNEL = Darwin ]; then
        PATH="$PATH:/Applications/Postgres.app/Contents/MacOS/bin"
    fi


### Load local environment

    LOCALENV=$HOME/.private/etc/zshrc
    if [ -f $LOCALENV ]; then
        source $LOCALENV
    fi
