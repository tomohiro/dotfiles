#!/bin/sh

readonly DOTFILES=$(cd $(dirname $0)/.. && pwd)

make -C $DOTFILES install
