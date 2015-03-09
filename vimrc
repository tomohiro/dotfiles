" NeoBundle is Vim plugin manager based on Vundle(https://github.com/gmarik/vundle).
"   [Shougo/neobundle.vim](https://github.com/Shougo/neobundle.vim)
"
" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

if has('vim_starting')
  set nocompatible               " be iMproved

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" let NeoBundle manage NeoBundle
" required!
NeoBundleFetch 'Shougo/neobundle.vim'

" Completion and snippets
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'ujihisa/neco-look'

" Editing
NeoBundle 'h1mesuke/vim-alignta'
NeoBundle 't9md/vim-textmanip'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'Townk/vim-autoclose'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'coderifous/textobj-word-column.vim'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'mhinz/vim-signify'

" Project support
NeoBundle 'supermomonga/projectlocal.vim'

" Tools
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'mattn/ctrlp-ghq'
NeoBundle 'tpope/vim-repeat'

" Themes
NeoBundle 'tomasr/molokai'

" Buffer management
NeoBundle 'fholgado/minibufexpl.vim'

" Statusline
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'pwdstatus.vim'

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

" Encoding
"
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,cp932
set fileformats=unix,dos

" Vim Default Option:
"
set complete+=k
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set wildmenu
set nobackup
set noswapfile
set nowritebackup
set backspace=indent,eol,start
set directory=/tmp//
set hlsearch
set iminsert=0
set imsearch=0
set ignorecase
set smartcase
set incsearch
set wrapscan
set ww=31
set mouse=a
set ttymouse=xterm2
set ttyfast
set autoread
"set clipboard+=autoselect
"set clipboard+=unnamed

" Visual
"
syntax enable
set visualbell
set number
set ruler
"set nowrap
set ambiwidth=double
set showcmd
set showmatch
set list
set listchars=tab:>_,trail:_,eol:↩
set cursorline
augroup cch
    autocmd! cch
    autocmd WinLeave * set nocursorline
    autocmd WinEnter,BufRead * set cursorline
augroup END
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=black
match ZenkakuSpace /　/


" Fold
"
set foldenable
set foldmethod=marker
set foldcolumn=1


" Enable Plugin
"
filetype plugin on
filetype indent on


" Change Leader key into a comma instead of a backslash
"
let mapleader=','


" Reload configuration
"
nnoremap <silent> <Leader>s :source $HOME/.vimrc<CR>

" Refresh display
"
nnoremap <silent> <Leader>r :redraw!<CR>


" for Vim Keybinding Customize
"
nnoremap j gj
nnoremap k gk
imap jj <ESC>
imap kk <ESC>


" remove highlight
"
nnoremap <silent> <ESC> <ESC> :nohlsearch<CR>


" for Split Window Keybinding
"
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

nmap <Space>pj <SID>(split-to-j)
nmap <Space>pk <SID>(split-to-k)
nmap <Space>ph <SID>(split-to-h)
nmap <Space>pl <SID>(split-to-l)

nnoremap <silent> <SID>(split-to-j) :<C-u>execute 'belowright' (v:count == 0 ? '' : v:count) 'split'<CR>
nnoremap <silent> <SID>(split-to-k) :<C-u>execute 'aboveleft'  (v:count == 0 ? '' : v:count) 'split'<CR>
nnoremap <silent> <SID>(split-to-h) :<C-u>execute 'topleft'    (v:count == 0 ? '' : v:count) 'vsplit'<CR>
nnoremap <silent> <SID>(split-to-l) :<C-u>execute 'botright'   (v:count == 0 ? '' : v:count) 'vsplit'<CR>


" encoding
"
nmap <silent> eu :set fenc=utf-8<CR>
nmap <silent> ee :set fenc=euc-jp<CR>
nmap <silent> es :set fenc=cp932<CR>


" encode reopen encoding
"
nmap <silent> eru :e ++enc=utf-8 %<CR>
nmap <silent> ere :e ++enc=euc-jp %<CR>
nmap <silent> ers :e ++enc=cp932 %<CR>
nmap <silent> err :e %<CR>


" for FileType
"
autocmd BufRead *.md    :set ts=4 sw=4 ft=markdown
autocmd BufRead *.ihtml :set ft=php
autocmd BufRead *.txt   :set ft=markdown ff=dos
autocmd FileType php    :set ts=4 sw=4
autocmd FileType go     :set ts=4 sw=4 noexpandtab


" for omnifunc
"
set pumheight=15
hi Pmenu       ctermbg=darkgray
hi PmenuSel    ctermbg=blue
hi PmenuSbar   ctermbg=white
hi TabLine     ctermbg=white
hi TabLineSel  ctermbg=red
hi TabLineFill ctermbg=white


" for PHP
"
let php_sql_query     = 1
let php_htmlInStrings = 1
let php_folding       = 0


" for ChangeLog
"
let g:changelog_username = "Tomohiro <tomohiro.t@gmail.com>"


" for toggle line numbers
"
function! NumberToggle()
    if (&relativenumber == 1)
        set norelativenumber
    else
        set relativenumber
    endif
endfunc
nnoremap <silent> <Leader>n :call NumberToggle()<CR>


" for vim-textmanip
"
vmap <C-j> <Plug>(textmanip-move-down)
vmap <C-k> <Plug>(textmanip-move-up)
vmap <C-h> <Plug>(textmanip-move-left)
vmap <C-l> <Plug>(textmanip-move-right)

vmap <M-d> <Plug>(textmanip-duplicate-down)
nmap <M-d> <Plug>(textmanip-duplicate-down)


" for neocomplcache.vim
"
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_underbar_completion = 1


" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  "return neocomplcache#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()


" for vim-indent-guides
"
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=235
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=235


" for NERDCommenter
"   [NERDCommenterで瞬時にコメントをトグるためのショートカット設定 #Vim - Qiita](http://qiita.com/items/b69b41ad4ea2497b3477)
let NERDSpaceDelims = 1
nmap <Leader>c <Plug>NERDCommenterToggle
vmap <Leader>c <Plug>NERDCommenterToggle


" for lightline.vim
"   [itchyny/lightline.vim](https://github.com/itchyny/lightline.vim)
"
let g:lightline = {
      \ 'component': {
      \   'readonly': '%{&readonly?"⭤":""}',
      \ },
      \ 'separator': { 'left': '⮀', 'right': '⮂' },
      \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
      \ }

" for ctrlp.vim
"   [ctrlp.vim ÷ home](http://kien.github.com/ctrlp.vim/)
"
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,tar.gz,tgz  " MacOSX/Linux
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'

" for ctrlp-ghq
"   [mattn/ctrlp-ghq](https://github.com/mattn/ctrlp-ghq)
nmap <Leader>j :CtrlPGhq<CR>

" for EasyMotion
"   [Lokaltog/vim-easymotion](https://github.com/Lokaltog/vim-easymotion/)
"   [【Vim】目的の行に素早く移動する（相対行番号と easymotion プラグイン）](http://blog.remora.cx/2012/08/vim-easymotion.html)
"
let g:EasyMotion_keys='hjklasdfgyuiopqwertnmzxcvbHJKLASDFGYUIOPQWERTNMZXCVB' " Use home position keys


" for Vim colorscheme
"
colorscheme molokai
hi LineNr     ctermbg=235 ctermfg=105
hi StatusLine ctermbg=64  ctermfg=15
hi clear CursorLine
hi CursorLine gui=underline
hi CursorLine ctermbg=235 guibg=235
