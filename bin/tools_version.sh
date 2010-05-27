#!/bin/sh

zsh=`zsh --version`
vim=`vim --version | head -n 1`
screen=`screen --version`
ruby=`ruby -v`
gem=`gem -v`
echo $zsh
echo $vim
echo $screen
echo $ruby
echo "RubyGems $gem"
