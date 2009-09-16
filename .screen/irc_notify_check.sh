#!/bin/bash
test -e .irssi/fnotify && echo ' @IRC('`wc -l .irssi/fnotify | sed 's/\s\S*//'`') '
