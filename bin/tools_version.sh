#!/bin/sh

echo `zsh --version`
echo `vim --version | head -n 1`
echo `screen --version`
echo `irssi --version`


echo ' '
echo 'Programming Development'

echo `ruby -v`
echo "RubyGems" `gem -v`
echo `perl --version | grep This`
echo `python --version | head -n 1`
