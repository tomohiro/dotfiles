#!/usr/bin/env bash

LC_ALL=C

# for tmux-powerline: https://github.com/erikw/tmux-powerline
if [ $KERNEL = Darwin ]; then
  export PLATFORM=mac
else
  export PLATFORM=linux
fi
