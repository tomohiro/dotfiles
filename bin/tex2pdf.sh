#!/bin/sh
NAME=`basename $1 .tex`

nkf -We $NAME.tex > $NAME.euc
platex $NAME.euc
dvipdf $NAME.dvi

rm $NAME.dvi $NAME.aux $NAME.log $NAME.out $NAME.euc > /dev/null 2>&1
