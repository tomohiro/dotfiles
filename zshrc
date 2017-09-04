## Autoload settings

    autoload -U colors
    colors

    fpath=($HOME/.zsh/completions $HOME/.zsh/functions $fpath)
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

    _cache_hosts=(`perl -ne 'if (/^([a-zA-Z0-9.-]+)/) { print "$1\n";}' ~/.ssh/known_hosts`)

    unalias run-help
    autoload run-help
    HELPDIR=$HOMEBREW_ROOT/share/zsh/help

## Set shell options

    setopt auto_menu auto_cd correct auto_name_dirs auto_remove_slash
    setopt extended_history hist_ignore_dups hist_ignore_space prompt_subst
    setopt pushd_ignore_dups rm_star_silent sun_keyboard_hack
    setopt extended_glob list_types no_beep always_last_prompt
    setopt cdable_vars auto_param_keys share_history
    setopt long_list_jobs magic_equal_subst auto_pushd
    setopt print_eight_bit noflowcontrol
    setopt multibyte combining_chars
    setopt sh_word_split


## Reporttime Settings

    REPORTTIME=3


## History settings

    HISTFILE=$HOME/.zsh-history
    HISTSIZE=100000
    SAVEHIST=100000


## Keybind settings

    bindkey -v
    bindkey '^Q' push-line-or-edit
    bindkey '^R' history-incremental-search-backward


## Set Aliases

    alias cp='nocorrect cp'
    alias mv='nocorrect mv'
    alias rm='nocorrect rm'
    alias mkdir='nocorrect mkdir'
    alias sl='ls'
    alias tree='tree --charset=C'
    alias fuck='eval $(thefuck $(fc -ln -1 | tail -n 1)); fc -R'

    alias ls='ls -hF -G -v'
    alias la='ls -lAh'
    alias ll='ls -lh'

    alias vi=$EDITOR
    alias rake='noglob rake'

    if type colordiff &> /dev/null; then
        alias diff='colordiff'
    fi

    if type assh &> /dev/null; then
        alias ssh='assh wrapper ssh'
    fi

    if type ccat &> /dev/null; then
      alias cat='ccat'
    fi

    alias b='bundle'
    alias d='downcer'
    alias j='ghq list -p | peco --layout bottom-up | while read SRC_PATH; do cd $SRC_PATH; done'
    alias m='warp'
    alias s='spot'
    alias v='pecrant'

    alias ssh-new=ssh_on_screen


## Global alias

    if type pbcopy &> /dev/null; then # Mac
        alias -g C='| pbcopy'
    elif type xsel &> /dev/null; then # Linux
        alias -g C='| xsel --input --clipboard'
    fi

    alias -g M='| more'
    alias -g L='| less'
    alias -g X='| xargs'
    alias -g H='| w3m -T text/html'


## Set Functions

    # load my functions
    local func_dir=$HOME/.zsh/functions
    for script in $(command ls $func_dir); do
        source $func_dir/$script
    done

    preexec() {
        [[ -n $WINDOW ]] && set_screen_window_title ${(z)2}
    }

## Set other zsh sources

    local source_dir=$HOME/.zsh/autoload
    for source in $(command ls $source_dir/*.zsh); do
        source $source
    done
