#!/bin/zsh
# Configuration for Keychain
#   - https://www.funtoo.org/Keychain
if type keychain &> /dev/null; then
  KEYCHAIN_HOME=$XDG_CACHE_HOME/keychain
  SSH_AGENT=$KEYCHAIN_HOME/$(hostname)-sh
  keychain -q $HOME/.ssh/id_rsa --dir $KEYCHAIN_HOME
  source $SSH_AGENT
fi
