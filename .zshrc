##### Set Local Options #####
local BLACK=$'%{\e[00;47;30m%}'
local RED=$'%{\e[00;31m%}'
local GREEN=$'%{\e[00;32m%}'
local YELLOW=$'%{\e[00;33m%}'
local BLUE=$'%{\e[00;34m%}'
local MAGENTA=$'%{\e[00;35m%}'
local CYAN=$'%{\e[00;36m%}'
local WHITE=$'%{\e[00;37m%}'

##### Prompt Settings #####
PROMPT=$RED'[%n@%m]'$YELLOW'[%d]'$GREEN'
:-) '$WHITE

##### Environment Settings #####
export SHELL=zsh
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
export EDITOR=`which vim`
export SVN_EDITOR=$EDITOR
export PAGER=lv
export LISTMAX=10000
export GEM_PATH=/var/lib/gems/1.8/bin
export PATH=$GEM_PATH:$PATH:~/scratch/
export TERM=xterm-256color
export TERM_256=$TERM
export LS_COLORS='di=01;36'

###### Auto Load Settings #####
autoload -U colors
colors

autoload -U compinit
compinit

zstyle ':completion:*:sudo:*' command-path $PATH
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:processes' command 'ps x'
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

_cache_hosts=(`perl -ne  'if (/^([a-zA-Z0-9.-]+)/) { print "$1\n";}' ~/.ssh/known_hosts`)

##### Set Shell Options #####
setopt auto_menu auto_cd correct auto_name_dirs auto_remove_slash
setopt extended_history hist_ignore_dups hist_ignore_space prompt_subst
setopt pushd_ignore_dups rm_star_silent sun_keyboard_hack
setopt extended_glob list_types no_beep always_last_prompt
setopt cdable_vars sh_word_split auto_param_keys share_history
setopt long_list_jobs magic_equal_subst auto_pushd
setopt print_eight_bit noflowcontrol

##### History Settings #####
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000

##### Keybind Settings #####
bindkey -v
bindkey '^Q' push-line-or-edit
bindkey '^R' history-incremental-search-backward

##### Set Library #####
#export LD_LIBRARY_PATH=/usr/lib/oracle/10.2.0.1/client/lib

# For Oracle
#export NLS_LANG=Japanese_Japan.JA16SJIS
#export NLS_TIMESTAMP_FORMAT="YYYY-MM-DD HH24:MI:SS"

# For DB2
#export DB2CODEPAGE=943

##### Set Aliases #####
alias cp='nocorrect cp'
alias mv='nocorrect mv'
alias rm='nocorrect rm'
alias mkdir='nocorrect mkdir'

alias ls='ls -hF --color'
alias la='ls -lAh'
alias ll='ls -lh'

# Application Aliases
alias vi=$EDITOR
alias diff='colordiff'

# Suffix Aliases
alias -s txt=$EDITOR
alias -s xml=$EDITOR
alias -s log='tail -f'
alias -s tgz='tar zxvf'
alias -s tar.gz='tar zxvf'

##### Set Functions #####
#
# Google Search
function google() {
    local str opt
    if [ $# != 0 ]; then 
        for i in $*; do
            str="$str+$i"
        done
        str=`echo $str | sed 's/^\+//'`
        opt='search?num=50&hl=ja&ie=utf-8&oe=utf-8&lr=lang_ja'
        opt="${opt}&q=${str}"
    fi
    command w3m http://www.google.co.jp/$opt
}

# screen window title set at exec command
if [ $TERM = $TERM_256 ]; then
    chpwd () { echo -n "_`dirs`\\" }
    preexec() {
        # see [zsh-workers:13180]
        # http://www.zsh.org/mla/workers/2000/msg03993.html
        emulate -L zsh
        local -a cmd; cmd=(${(z)2})
        case $cmd[1] in
            fg)
                if (( $#cmd == 1 )); then
                    cmd=(builtin jobs -l %+)
                else
                    cmd=(builtin jobs -l $cmd[2])
                fi
                ;;
            %*) 
                cmd=(builtin jobs -l $cmd[1])
                ;;
            cd)
                if (( $#cmd == 2)); then
                    cmd[1]=$cmd[2]
                fi
                ;&
            *)
                echo -n "k$cmd[1]:t\\"
                return
                ;;
        esac

        local -A jt; jt=(${(kv)jobtexts})

        $cmd >>(read num rest
                 cmd=(${(z)${(e):-\$jt$num}})
                 echo -n "k$cmd[1]:t\\") 2>/dev/null
    }
    chpwd
fi

# screen completion
HARDCOPYFILE=$HOME/tmp/screen-hardcopy
touch $HARDCOPYFILE

dabbrev-complete () {
        local reply lines=80
        screen -X eval "hardcopy -h $HARDCOPYFILE"
        reply=($(sed '/^$/d' $HARDCOPYFILE | sed '$ d' | tail -$lines))
        compadd - "${reply[@]%[*/=@|]}"
}

zle -C dabbrev-complete menu-complete dabbrev-complete
bindkey '^o' dabbrev-complete
bindkey '^o^_' reverse-menu-complete

# Function For Screen
if [ $TERM = $TERM_256 ]; then
    alias ssh=ssh_screen
fi
function ssh_screen() {
    eval server=\${$#}
    screen -t $server ssh "$@"
}
