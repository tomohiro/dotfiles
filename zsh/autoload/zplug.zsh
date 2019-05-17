#!/bin/zsh

# zplug document (JP)
# https://github.com/zplug/zplug/blob/master/doc/guide/ja/README.md

# Configure zplug options
typeset -x ZPLUG_HOME=/usr/local/opt/zplug
typeset -x ZPLUG_EXTERNAL=/dev/null

# Load zplug functions
source $ZPLUG_HOME/init.zsh

# Zsh Plugins
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"

# zplug plugins
zplug "plugins/docker-compose", from:oh-my-zsh
zplug "m4i/cdd", use:cdd

# CLI tools
zplug "tomohiro/dotfiles", as:command, use:"bin/{*}"
zplug "tomohiro/warp", as:command
zplug "tomohiro/p", as:command
zplug "tomohiro/h", as:command
zplug "gongo/pecrant", as:command
zplug "gongo/tpdiff", as:command
zplug "kinjo/geed", as:command, use:"geed-*"
zplug "kyanny/git-prune-remote-branch", as:command
zplug "ryanmjacobs/c", as:command
zplug "guille/spot", as:command, use:spot.sh, rename-to:spot
zplug "vigneshwaranr/bd", as:command
zplug "paulirish/git-open", as:command, use:git-open
zplug "mgedmin/2762225", from:gist, as:command, use:show-all-256-colors.py, rename-to:256colors

# Set environment variables to zplug managed tools/functions/plugins
export CDD_FILE=$ZSH_DATA_HOME/cdd-history

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Load Zsh plugins and then add these to the PATH.
# If you want to see detail, add `--verbose` option when runs `zplug load`.
zplug load --verbose
