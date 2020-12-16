#!/usr/bin/env zsh

function peco-select-repository() {
  ghq list -p | \
    peco --layout bottom-up | \
    while read REPO_PATH; do
      cd ${REPO_PATH}
    done

  zle clear-screen
}
zle -N peco-select-repository
