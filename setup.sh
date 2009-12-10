#!/bin/sh

ln -s -f $HOME/Dropbox/Development $HOME/

cd $HOME/Development/dotfiles/

ln -s -f .profile $HOME/
ln -s -f .zshrc $HOME/
ln -s -f .vim $HOME/
ln -s -f .vimrc $HOME/
ln -s -f .vimperatorrc $HOME/
ln -s -f .vimperator $HOME/
ln -s -f .git $HOME/
ln -s -f .gitconfig $HOME/
ln -s -f .irbrc $HOME/
ln -s -f .screenrc $HOME/
ln -s -f .screen $HOME/
ln -s -f .ssh $HOME/
ln -s -f .irssi $HOME/

OS=`uname`

if [ $OS = ]; then
    ln -s -f .network $HOME/
else
    ln -s -f .inputrc $HOME/
fi
