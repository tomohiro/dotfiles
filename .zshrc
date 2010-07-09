##### Environment Settings #####
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

##### Prompt Settings #####
PROMPT="%F{red}[%n@%m]%F{yellow}[%d]%1(v|%F{green}%1v%f|)%F{cyan}
:-) %F{white}"

###### Auto Load Settings #####
autoload -U colors
colors

fpath=($HOME/.zsh/functions $fpath)
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

autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%r/%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%r/%b|%a]'
zstyle ':vcs_info:*' branchformat '%b:%r'

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

##### Set Database Settings #####

# For Oracle
#export LD_LIBRARY_PATH=/usr/lib/oracle/10.2.0.1/client/lib
#export NLS_LANG=Japanese_Japan.JA16SJIS
#export NLS_TIMESTAMP_FORMAT="YYYY-MM-DD HH24:MI:SS"

# For DB2
#export DB2CODEPAGE=943

# For PostgreSQL
#if [ $OS = Darwin ]; then
#    export PATH=/opt/local/lib/postgresql84/bin:$PATH
#fi

##### Set Aliases #####
alias cp='nocorrect cp'
alias mv='nocorrect mv'
alias rm='nocorrect rm'
alias mkdir='nocorrect mkdir'
alias sudo='sudo '
alias sl='ls'

if [ $OS = Darwin ]; then
    alias ls='ls -hF -G'
else
    alias open='gnome-open'
    alias ls='ls -hF --color=auto'
fi
alias la='ls -lAh'
alias ll='ls -lh'

# Application Aliases
alias vi=$EDITOR
alias diff='colordiff'
alias irssi="irssi --config=$HOME/.irssi/config.$OS"
alias ssh=ssh_on_screen
alias site="vi $HOME/Development/tomohiro.github.com/markdown"

# Alias for todo.sh
alias t=`which todo.sh`
alias tl='t ls'
alias tp='t projectview'

##### Set Functions #####
#
# load my functions
local func_dir=$HOME/.zsh/functions
for script in `ls $func_dir`; do
    source $func_dir/$script
done

preexec() {
    [[ -n $WINDOW ]] && set_screen_window_title ${(z)2}
}

precmd() {
    psvar=()
    # VCS info
    LANG=en_US.UTF-8 vcs_info
    [[ -n $vcs_info_msg_0_ ]] && psvar[1]="$vcs_info_msg_0_"

    # Check background process for Growl or notify-send
    check_background_process.rb `history -n -1 | head -1`
}

chpwd() {
    _reg_pwd_screennum
    ls
}

# screen completion
HARDCOPYFILE=/tmp/screen-hardcopy
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

# Startup Message
fortune
