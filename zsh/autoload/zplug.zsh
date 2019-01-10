#!/bin/zsh

# Configure zplug options
typeset -x ZPLUG_HOME=/usr/local/opt/zplug
typeset -x ZPLUG_EXTERNAL=/dev/null

# Load zplug functions
source $ZPLUG_HOME/init.zsh

# Zsh Plugins
zplug 'zsh-users/zsh-syntax-highlighting'
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-completions'
zplug 'zsh-users/zsh-history-substring-search'

# zplug plugins
zplug 'plugins/docker-compose', from:oh-my-zsh
zplug 'm4i/cdd', use:cdd

# CLI tools
zplug 'Tomohiro/warp', as:command
zplug 'Tomohiro/p', as:command
zplug 'Tomohiro/h', as:command
zplug 'gongo/pecrant', as:command
zplug 'gongo/tpdiff', as:command
zplug 'kinjo/geed', as:command, use:'geed-*'
zplug 'kyanny/git-prune-remote-branch', as:command
zplug 'ryanmjacobs/c', as:command
zplug 'guille/spot', as:command, use:'spot.sh', rename-to:spot
zplug 'vigneshwaranr/bd', as:command
zplug "paulirish/git-open", as:plugin


# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Load Zsh plugins and then add these to the PATH.
# If you want to see detail, add `--verbose` option when runs `zplug load`.
zplug load
