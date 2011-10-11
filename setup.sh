#!/bin/bash

# Setting environment variables

      OS=`uname`
      DEV_PATH=$HOME/Dropbox/Development
      DOTFILES_PATH=$DEV_PATH/dotfiles
      SCRIPT_NAME=$DOTFILES_PATH/`basename $0`

      cd $DOTFILES_PATH

      echo "$SCRIPT_NAME\nStarting..."

# Setting ignore files

      IGNORES=(bin _vimperatorrc README.mkdn setup.sh)
      case $KERNEL in
          Linux)  IGNORES=(${IGNORES[@]} profile) ;;
          Darwin) IGNORES=(${IGNORES[@]} bash_profile fonts.conf gemrc) ;;
      esac



# Make base directories symlinks

      echo "\n  Make base directories symlinks."

      ln -s -f $DEV_PATH $HOME/
      echo "    [Dir]   $HOME/Development@ -> $DEV_PATH"

      ln -s -f $DOTFILES_PATH/bin $HOME/
      echo "    [Dir]   $HOME/bin@ -> $DOTFILES_PATH/bin"



# Make dotfiles symlinks

      echo "\n  Make dotfiles symlinks."

      for i in `ls $DOTFILES_PATH`; do
          for ignore in ${IGNORES[@]}; do
              if [ $i == $ignore ]; then
                  continue 2
              fi
          done


          if [ -h $HOME/.$i ]; then
              rm $HOME/.$i
              echo "    [Del]   $HOME/.$i@"
          fi

          ln -s $DOTFILES_PATH/$i $HOME/.$i

          if [ -d $i ]; then
              echo "    [Dir]   $HOME/.$i@ -> $DOTFILES_PATH/$i"
          else
              echo "    [File]  $HOME/.$i@ -> $DOTFILES_PATH/$i"
          fi
      done



# Apply execute permissions

      echo "\n  Apply exexute permissions."

      BIN_DIRS=( bin .screen/scripts .irssi/scripts )
      for bin in ${BIN_DIRS[@]}; do
          chmod +x $HOME/$bin/*
          echo "    [Bin] +x  $HOME/$bin"
      done



      echo "\nFinished"
