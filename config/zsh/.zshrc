# vim: ft=zsh

# Report CPU usage for commands running longer than 3 seconds
REPORTTIME=3

# History settings
HISTFILE="${ZSH_DATA_HOME}/zsh-history"
HISTSIZE=100000
SAVEHIST=100000

# Completion Configuration
fpath=(${ZDOTDIR} $(brew --prefix)/share/zsh-completions ${fpath})
# Additionally, if you receive "zsh compinit: insecure directories" warnings
# when attempting to load these completions, you may need to run this:
#   $ chmod go-w '/usr/local/share'
autoload -Uz compinit && compinit
zstyle ':completion:*:sudo:*' command-path ${PATH}
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:processes' command 'ps x'
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# For SSH completion
_cache_hosts=($(grep -oE '^Host.+$' "${HOME}/.ssh/config" | cut -d ' ' -f 2))

# Set shell options
setopt auto_menu auto_cd correct auto_name_dirs auto_remove_slash
setopt extended_history hist_ignore_dups hist_ignore_space prompt_subst
setopt pushd_ignore_dups rm_star_silent sun_keyboard_hack
setopt extended_glob list_types no_beep always_last_prompt
setopt cdable_vars auto_param_keys share_history
setopt long_list_jobs magic_equal_subst auto_pushd
setopt print_eight_bit noflowcontrol
setopt multibyte combining_chars
setopt sh_word_split
setopt interactivecomments

# Set builtin command aliases
alias cp='nocorrect cp'
alias mv='nocorrect mv'
alias rm='nocorrect rm'
alias mkdir='nocorrect mkdir'
alias sl='ls'
alias ls='ls -hF -G -v'
alias la='ls -lAh'
alias ll='ls -lh'
alias tree='tree --charset=C'

# Set additional command aliases
__is_installed mdfind && alias locate='mdfind'
__is_installed colordiff && alias diff='colordiff'
__is_installed ccat && alias cat='ccat'

# Set short aliases
alias b='bundle'
alias d='downcer'
alias e='env | peco --layout bottom-up'
alias j='ghq list -p | peco --layout bottom-up | while read SRC_PATH; do cd $SRC_PATH; done'
alias m='warp'
alias s='spot'
alias v='pecrant'

# Global aliases
alias -g M='| more'
alias -g L='| less'
alias -g X='| xargs'
__is_installed w3m && alias -g H='| w3m -T text/html'
__is_installed pbcopy && alias -g C='| pbcopy'

# Load other Zsh scripts, functions
for script in $(ls ${ZDOTDIR}/*.zsh); do
  source ${script}
done
