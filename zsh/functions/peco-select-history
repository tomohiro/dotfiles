#!/usr/bin/env zsh

# pecoを導入してzshのhistoryに使うようにした - さよならインターネット
# http://blog.kenjiskywalker.org/blog/2014/06/12/peco/
#
# This function used at $HOME/.zsh/autoload/vi-mode.zsh
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac='tac'
    else
        tac='tail -r'
    fi
    BUFFER=$(history -n 1 | \
        eval $tac | \
        peco --layout bottom-up --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
