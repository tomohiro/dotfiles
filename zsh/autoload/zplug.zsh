#!/bin/zsh

# Configure zplug options
typeset -x ZPLUG_HOME=$HOME/.zsh
typeset -x ZPLUG_EXTERNAL=/dev/null

# Load zplug functions
source $ZPLUG_HOME/repos/b4b4r07/zplug/zplug

# Zsh Plugins
zplug 'b4b4r07/zplug'
zplug 'zsh-users/zsh-syntax-highlighting'
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-completions'
zplug 'zsh-users/zsh-history-substring-search'

# CLI tools
zplug 'Tomohiro/warp', as:command
zplug 'Tomohiro/p', as:command
zplug 'Tomohiro/h', as:command
zplug 'gongo/pecrant', as:command
zplug 'kinjo/geed', as:command
zplug 'kyanny/git-prune-remote-branch', as:command
zplug 'ryanmjacobs/c', as:command
zplug 'guille/spot', as:command, file:spot
zplug 'vigneshwaranr/bd', as:command


# Install all Zsh plugins if these are not installed.
zplug check || zplug install

# Load Zsh plugins and then add these to the PATH.
# If you want to see detail, add `--verbose` option when runs `zplug load`.
zplug load
