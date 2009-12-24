#!/bin/bash
if [ $OS = Darwin ]; then
    alias sed='gsed'
fi

test -e .irssi/fnotify && echo ' @IRC('`wc -l .irssi/fnotify | sed 's/\s\S*//'`') '
