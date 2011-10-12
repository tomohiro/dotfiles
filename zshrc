# vim: set ft=zsh:

## Default environment settings

    export SHELL=zsh
    export LANG=ja_JP.UTF-8
    export LC_ALL=$LANG
    export EDITOR=`which vim`
    export SVN_EDITOR=$EDITOR
    export PAGER=lv
    export LISTMAX=10000
    export TERM_256=xterm-256color
    export TERM=$TERM_256
    export LS_COLORS='di=01;36'
    export KERNEL=`uname`
    export PATH=/usr/local/bin:/usr/local/sbin:$PATH

    if [ $KERNEL = Darwin ]; then
        export PATH=/opt/X11/bin:$PATH
    fi


## for Ruby `rvm`

    if [[ -s $HOME/.rvm/scripts/rvm ]]; then
        source $HOME/.rvm/scripts/rvm
    fi


## for Python `pythonbrew`

    if [[ -s $HOME/.pythonbrew/etc/bashrc ]]; then
        source $HOME/.pythonbrew/etc/bashrc
    fi


## for Perl `perlbrew`

    if [[ -s $HOME/.perlbrew/perl5/etc/bashrc ]]; then
        source $HOME/.perlbrew/perl5/etc/bashrc;
    fi


## for cpanminus

    if which cpanm > /dev/null 2>&1 && [ -n $PERLBREW_ROOT ]; then
        export PERL_CPANM_OPT=--local-lib=$PERLBREW_ROOT
        export PERL5LIB=$PERLBREW_ROOT/lib/perl5:$PERL5LIB
    fi


## for Android

    if [ $KERNEL = Darwin -a -d $HOME/Library/android-sdk-x86/tools ]; then
        export PATH=$HOME/Library/android-sdk-x86/tools:$PATH
    fi


## for node.js and npm

    if which npm > /dev/null 2>&1; then
        export NODE_PATH=/usr/local/lib/node
    fi


    export PATH=$HOME/bin:$PATH

## Auto load settings

    autoload -U colors
    colors

    fpath=($HOME/.zsh/functions $fpath)
    autoload -U compinit
    compinit

    autoload -Uz zmv
    #alias zmv='noglob zmv -W'

    zstyle ':completion:*:sudo:*' command-path $PATH
    zstyle ':completion:*:default' menu select=1
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
    zstyle ':completion:*:processes' command 'ps x'
    zstyle ':completion:*' verbose yes
    zstyle ':completion:*:descriptions' format '%B%d%b'
    zstyle ':completion:*:messages' format '%d'
    zstyle ':completion:*:warnings' format 'No matches for: %d'
    zstyle ':completion:*' group-name ''

    autoload -Uz vcs_info
    zstyle ':vcs_info:*' formats '(%s)-[%r/%b]'
    zstyle ':vcs_info:*' actionformats '(%s)-[%r/%b|%a]'
    zstyle ':vcs_info:*' branchformat '%b:%r'

    _cache_hosts=(`perl -ne  'if (/^([a-zA-Z0-9.-]+)/) { print "$1\n";}' ~/.ssh/known_hosts`)


## Set shell options

    setopt auto_menu auto_cd correct auto_name_dirs auto_remove_slash
    setopt extended_history hist_ignore_dups hist_ignore_space prompt_subst
    setopt pushd_ignore_dups rm_star_silent sun_keyboard_hack
    setopt extended_glob list_types no_beep always_last_prompt
    setopt cdable_vars auto_param_keys share_history
    setopt long_list_jobs magic_equal_subst auto_pushd
    setopt print_eight_bit noflowcontrol
    # setopt sh_word_split # comment out. rvm not working.


## History settings

    HISTFILE=$HOME/.zsh-history
    HISTSIZE=100000
    SAVEHIST=100000


## Keybind settings

    bindkey -v
    bindkey '^Q' push-line-or-edit
    bindkey '^R' history-incremental-search-backward


## Set Database settings

### For Oracle

    export LD_LIBRARY_PATH=/usr/lib/oracle/10.2.0.1/client/lib
    export NLS_LANG=Japanese_Japan.JA16SJIS
    export NLS_TIMESTAMP_FORMAT="YYYY-MM-DD HH24:MI:SS"

### For DB2

    export DB2CODEPAGE=943


### For PostgreSQL

    if [ $KERNEL = Darwin ]; then
        export PATH=/opt/local/lib/postgresql84/bin:$PATH
    fi


## Set Aliases

    alias cp='nocorrect cp'
    alias mv='nocorrect mv'
    alias rm='nocorrect rm'
    alias mkdir='nocorrect mkdir'
    alias sl='ls'
    alias u='cd ../'
    alias b='cd -'
    alias :q='exit'

    if [ $KERNEL = Darwin ]; then
        alias ls='ls -hF -G'
    else
        alias open='gnome-open'
        alias ls='ls -hF --color=auto'
    fi
    alias la='ls -lAh'
    alias ll='ls -lh'

    alias vi=$EDITOR
    if which colordirff >/dev/null 2>&1; then
        alias diff='colordiff'
    fi
    if which ack-grep >/dev/null 2>&1; then # Ubuntu
        alias search='ack-grep'
    fi
    alias ssh=ssh_on_screen


## Global alias

    if which pbcopy >/dev/null 2>&1 ; then # Mac
        alias -g C='| pbcopy'
    elif which xsel >/dev/null 2>&1 ; then # Linux
        alias -g C='| xsel --input --clipboard'
    fi


## Set Functions

    # load my functions
    local func_dir=$HOME/.zsh/functions
    for script in `command ls $func_dir`; do
        source $func_dir/$script
    done

    preexec() {
        [[ -n $WINDOW ]] && set_screen_window_title ${(z)2}
    }

## Set other zsh source

    local source_dir=$HOME/.zsh
    for source in `command ls $source_dir/*.zshrc`; do
        source $source
    done


## Startup message

    256colors2.pl
    command fortune jojo
