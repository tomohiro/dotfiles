#!/bin/sh

ln -s -f $HOME/Dropbox/Development $HOME/

BASE=$HOME/Development/dotfiles/

ln -s -f $BASE.profile $HOME/
ln -s -f $BASE.zshrc $HOME/
ln -s -f $BASE.vim $HOME/
ln -s -f $BASE.vimrc $HOME/
ln -s -f $BASE.vimperatorrc $HOME/
ln -s -f $BASE.vimperator $HOME/
ln -s -f $BASE.gitconfig $HOME/
ln -s -f $BASE.irbrc $HOME/
ln -s -f $BASE.screen $HOME/
ln -s -f $BASE.ssh $HOME/
ln -s -f $BASE.irssi $HOME/

OS=`uname`

if [ $OS = Linux ]; then
    ln -s -f $BASE.network $HOME/
else
    ln -s -f $BASE.inputrc $HOME/
fi
