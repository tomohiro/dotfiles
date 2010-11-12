" for Charset Encoding 文字コードの自動認識
"
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

" Vim Option Settings
"
set complete+=k
set visualbell
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set number
set wildmenu
set viminfo=
set nobackup
set noswapfile
set nowritebackup
set backspace=indent,eol,start
set directory=/tmp/
set listchars=tab:>_
set list
set hlsearch
set iminsert=0
set imsearch=0
set ignorecase
set smartcase
set incsearch
set wrapscan
set ruler
set showcmd
set showmatch
set ambiwidth=double
set ww=31
set mouse=a
set ttymouse=xterm2

set laststatus=2
set statusline=%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%F%m%r%w%=<%3p%%><%4lL/%4LL:%02cC>

syntax on

" pathogenでftdetectなどをloadさせるために一度ファイルタイプ判定をoff
filetype off
" pathogen.vimによってbundle配下のpluginをpathに加える
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
set helpfile=$VIMRUNTIME/doc/help.txt
" ファイルタイプ判定をon
filetype plugin indent on

" 全角スペースを目立たせる
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=black
match ZenkakuSpace /　/

" for Vim Keybinding Customize
"
nnoremap j gj
nnoremap k gk

map <F1> :tabedit ~/
map <F2> :sp ~/
map <F3> <C-w>_
map <F4> <C-w>=
map <F7> :e# <Enter>
map <F8> :n <Enter>

" remove highlight
nmap <ESC><ESC> :nohlsearch<CR><ESC>

" for Split Window Keybinding
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

nmap <Space>pj <SID>(split-to-j)
nmap <Space>pk <SID>(split-to-k)
nmap <Space>ph <SID>(split-to-h)
nmap <Space>pl <SID>(split-to-l)

nnoremap <SID>(split-to-j) :<C-u>execute 'belowright' (v:count == 0 ? '' : v:count) 'split'<CR>
nnoremap <SID>(split-to-k) :<C-u>execute 'aboveleft'  (v:count == 0 ? '' : v:count) 'split'<CR>
nnoremap <SID>(split-to-h) :<C-u>execute 'topleft'    (v:count == 0 ? '' : v:count) 'vsplit'<CR>
nnoremap <SID>(split-to-l) :<C-u>execute 'botright'   (v:count == 0 ? '' : v:count) 'vsplit'<CR>

" encoding
nmap <silent> eu :set fenc=utf-8<CR>
nmap <silent> ee :set fenc=euc-jp<CR>
nmap <silent> es :set fenc=cp932<CR>

" encode reopen encoding
nmap <silent> eru :e ++enc=utf-8 %<CR>
nmap <silent> ere :e ++enc=euc-jp %<CR>
nmap <silent> ers :e ++enc=cp932 %<CR>
nmap <silent> err :e %<CR>

" for TeX Keybinding
map <C-p> :silent !tex2preview.sh % > /dev/null <Enter>

" for FileType Settings
"
autocmd BufRead .vimperatorrc   :set ft=vimperator
autocmd BufRead *screen*        :set ft=screen
autocmd BufRead *.ihtml         :set ft=php
autocmd BufRead *.go            :set ft=go
autocmd FileType ruby           :set ts=2 sw=2 fenc=utf-8
autocmd FileType php            :set makeprg=php\ -l\ % errorformat=%m\ in\ %f\ on\ line\ %l 
autocmd FileType php            :set dictionary=$HOME/.vim/dictionary/php.dict 
autocmd FileType yaml           :set fenc=utf-8
autocmd FileType css            :set fenc=utf-8
autocmd BufWritePost */markdown/*.mkd :silent !cg convert % > /dev/null && clifox -r
autocmd BufWritePost slide.mkdn :silent !slidedown % > slide.html && clifox -r
autocmd BufWritePost */wmf/*    :silent !clifox -h 172.16.5.222 -r "UnitTest"

" for clifor Keybinding
"map <C-r> :silent !clifox -h 172.16.5.222 -r <Enter>

" for PHP Settings
"
let php_sql_query=1
let php_htmlInStrings=1
let php_folding=0

" for Vim 7
if v:version >= 700
    " for Vim omnifunc Settings
    "
    set pumheight=15
    hi Pmenu ctermbg=darkgray
    hi PmenuSel ctermbg=blue
    hi PmenuSbar ctermbg=white
    hi TabLine ctermbg=white
    hi TabLineSel ctermbg=red
    hi TabLineFill ctermbg=white

    " for tab
    map <F5> gt
    map <F6> gT
endif

" for vim-ref
"
let g:ref_phpmanual_path = $HOME . '/.vim/manual/php'

" for neocomplcache.vim
"
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_underbar_completion = 1

" for GoogleTranslate
"
nmap <Space>l :Trans<CR>

" for zencoding.vim
" 
let g:user_zen_expandabbr_key = '<c-e>'  
let g:user_zen_settings = {'indentation' : '    '}

" for VimShell
"
let g:vimshell_user_prompt = 'getcwd()'

" for gtags.vim
map <C-g>  :Gtags -g 
map <C-g>f :Gtags -f %<CR>
map <C-g>r :Gtags -r <CR>
map <C-g>j :GtagsCursor<CR>
map <C-n>  :cn<CR>
map <C-p>  :cp<CR>
map <C-g>q <C-w><C-w><C-w>q

" for QFixHowm
set runtimepath+=~/.vim/bundle/qfixapp
let QFixHowm_Key      = 'g'
let howm_dir          = $HOME . '/Dropbox/howm'
let howm_filename     = '%Y/%m/%Y-%m-%d-%H%M%S.howm'
let howm_fileencoding = 'utf-8'
let howm_fileformat   = 'unix'

" for Vim colorscheme Settings
"
if filereadable($HOME . '/.vim/colors/inkpot.vim')
    colorscheme inkpot
elseif filereadable($HOME . '/.vim/bundle/inkpot/colors/inkpot.vim')
    colorscheme inkpot
else
    colorscheme desert
    set background=dark
endif
