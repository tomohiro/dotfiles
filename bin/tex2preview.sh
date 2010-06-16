#!/bin/sh

NAME=`basename $1 .tex`

tex2pdf.sh $1

READER=`which apvlv`
if [ $? = 0 ]; then
    $READER $NAME.pdf
else
    open $NAME.pdf
fi

rm $NAME.pdf
