#!/bin/bash

# Setting environment variables

      RED="\033[2;31m"
      GREEN="\033[2;32m"
      YELLOW="\033[2;33m"
      BLUE="\033[2;34m"
      MAGENTA="\033[2;35m"
      CYAN="\033[2;36m"
      WHITE="\033[2;37m"

      OS=`uname`
      DEV_PATH=$HOME/Dropbox/Development
      DOTFILES_PATH=$DEV_PATH/dotfiles
      SCRIPT_NAME=$DOTFILES_PATH/`basename $0`

      cd $DOTFILES_PATH

      echo "$SCRIPT_NAME\nStarting..."

# Setting ignore files

      IGNORES=(bin _vimperatorrc README.mkdn setup.sh)
      case $OS in
          Linux)
              IGNORES=(${IGNORES[@]} profile fonts.conf)
              ;;
          Darwin)
              IGNORES=(${IGNORES[@]} bash_profile fonts.conf gemrc)
              ;;
          *)
      esac



# Make base directories symlinks

      echo "$YELLOW\n  Make base directories symlinks.$WHITE"

      ln -s -f $DEV_PATH $HOME/
      echo "    $BLUE[Dir]  $WHITE $HOME/${MAGENTA}Development$WHITE@ -> $DEV_PATH"

      ln -s -f $DOTFILES_PATH/bin $HOME/
      echo "    $BLUE[Dir]  $WHITE $HOME/${MAGENTA}bin$WHITE@ -> $DOTFILES_PATH/bin"



# Make dotfiles symlinks

      echo "$YELLOW\n  Make dotfiles symlinks.$WHITE"

      for i in `ls $DOTFILES_PATH`; do
          for ignore in ${IGNORES[@]}; do
              if [ $i == $ignore ]; then
                  continue 2
              fi
          done


          if [ -h $HOME/.$i ]; then
              rm $HOME/.$i
              echo "    $RED[Del]  $WHITE $HOME/$MAGENTA.$i$WHITE@"
          fi

          ln -s $DOTFILES_PATH/$i $HOME/.$i

          if [ -d $i ]; then
              echo "    $BLUE[Dir]  $WHITE $HOME/$MAGENTA.$i$WHITE@ -> $DOTFILES_PATH/$i"
          else
              echo "    $CYAN[File] $WHITE $HOME/$MAGENTA.$i$WHITE@ -> $DOTFILES_PATH/$i"
          fi
      done



# Apply execute permissions

      echo "$YELLOW\n  Apply exexute permissions.$WHITE"

      BIN_DIRS=( bin .screen/scripts .irssi/scripts )
      for bin in ${BIN_DIRS[@]}; do
          chmod +x $HOME/$bin/*
          echo "    $CYAN[Bin] +x $WHITE $HOME/$bin"
      done



      echo "\nFinished"
