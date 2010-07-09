scriptencoding utf-8
" Vim syntax file
" Language: QFixHowm
" Written By: fuenor
" Maintainer: fuenor@gmail.com

"引用文
syn region txtQuote start="^\s*>\s" end="$"

"行頭の - +
syn region qfhList start="^\s*[-+]\+\s*" end=":" end="$" contains=qfhBullet,qfhColon,qfhFuncs,qfhError keepend

"行頭に空白を含む *
syn region qfhList start="^\s\+[*]\+\s*" end=":" end="$" contains=qfhBullet,qfhColon,qfhFuncs,qfhError keepend

"折りたたみ(*と章形式)
syn match  foldBullet contained "^[.*]\+\s*" contains=qfhError
syn region foldTitle start="^[*]" end=":" end="$" contains=foldBullet,qfhColon,qfhFuncs,qfhError,keepend

syn match  chapterBullet "^\s*[0-9][0-9.]* $"
syn match  chapterBullet "^\s*\(\*\.\)\+\*\?$"
syn match  chapterBullet "^\s*\.\+$"
syn match  chapterBullet contained "^\s*\([0-9.]\+\|[.*]\+\)"
syn region chapterTitle start="^\s*[0-9][0-9.]* " end=":" end="$" contains=chapterBullet,qfhColon,qfhFuncs,qfhError keepend
syn region chapterTitle start="^\s*\(\*\.\)\+\*\?" end="$" contains=chapterBullet,qfhColon,qfhFuncs,qfhError keepend
syn region chapterTitle start="^\.\+" end="$" contains=chapterBullet,qfhColon,qfhFuncs,qfhError keepend

syn match qfhBullet contained "^\s*[-+*]\+\s*" contains=qfhError
syn match qfhFuncs contained "(.\{-})" extend
syn match qfhFuncs contained "\[.\{-}]" extend
syn match qfhColon contained ":"

"syn match qfhMail contained "<[A-Za-z0-9\._:+-]\+@[A-Za-z0-9\._-]\+>"

syn region hatenaSuperPre   matchgroup=hatenaBlockDelimiter start=+^>|[^|]*|$+ end=+^||<$+

hi txtVoice guifg=lightblue
hi link txtQuote      Comment

hi link foldBullet    Type
hi link foldTitle     Define
hi link chapterBullet Type
hi link chapterTitle  Statement

hi link qfhBullet     Statement
hi link qfhColon      Label
hi link qfhList       Identifier
hi link qfhFuncs      Comment
hi link qfhError      Folded

hi link hatenaSuperPre          Comment
hi link hatenaBlockDelimiter    Delimiter

