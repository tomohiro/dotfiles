#!/bin/bash
if [ $KERNEL = Darwin ]; then
    alias sed='gsed'
fi

test -e .irssi/fnotify && echo ' @IRC('`wc -l .irssi/fnotify | sed 's/\s\S*//'`') '
