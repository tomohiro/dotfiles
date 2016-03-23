#!/bin/zsh

# Configure zplug options
typeset -x ZPLUG_HOME=$HOME/.zsh
typeset -x ZPLUG_EXTERNAL=/dev/null

# Load zplug functions
source $ZPLUG_HOME/repos/b4b4r07/zplug/zplug

# Plugins
zplug 'b4b4r07/zplug'
zplug 'zsh-users/zsh-syntax-highlighting'
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-completions'
zplug 'zsh-users/zsh-history-substring-search'

# Install all Zsh plugins if these are not installed.
zplug check || zplug install

# Load Zsh plugins and then add these to the PATH.
# If you want to see detail, add `--verbose` option when runs `zplug load`.
zplug load
