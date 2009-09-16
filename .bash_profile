#!/bin/bash
# .bash_profile

# keychain settings
HOST=`hostname`
KEYCHAIN=`which keychain`
IDENTITY=~/.ssh/id_rsa
SSH_AGENT=~/.keychain/$HOST-sh
$KEYCHAIN $IDENTITY
 . $SSH_AGENT

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
PATH=$HOME/bin:$PATH:/sbin:/usr/sbin
export PATH

# Network default settings
export http_proxy=
export HTTP_HOME=http://github.com/Tomohiro

case $TERM in
    linux) LANG=C ;;
    *) LANG=ja_JP.UTF-8 ;;
esac

# Change shell ( bash to zsh )
exec `which zsh`
unset USERNAME
