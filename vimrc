" VIM-PLUG A minimalist Vim plugin manager
"   https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

" Modern default configuration
Plug 'tpope/vim-sensible'

" Editing Support
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdcommenter'        " Intensely orgasmic commenting
Plug 'bronson/vim-trailing-whitespace' " Highlights trailing whitespace

" Completion
Plug 'Shougo/neocomplete'

" Appearance
Plug 'nathanaelkane/vim-indent-guides' " Change bgcolor for indent
Plug 'mhinz/vim-signify'               " Show git diff status on each line

" Themes
Plug 'joshdick/onedark.vim'

" Statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Syntax highlight
Plug 'chr4/nginx.vim'
Plug 'leafgarland/typescript-vim'

call plug#end()

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
set backspace=indent,eol,start
set hlsearch
set iminsert=0
set imsearch=0
set ignorecase
set smartcase
set incsearch
set wrapscan
set ww=31
set breakindent

" Set directory for backups, swaps, undo history
"
set backupdir=$HOME/.vim/backups
set directory=$HOME/.vim/swaps
set undodir=$HOME/.vim/undo

" Disable mouse
" set mouse=a
" set ttymouse=xterm2

set ttyfast
set autoread
"set clipboard+=autoselect
"set clipboard+=unnamed


" Reset autocmd
"
augroup vimrc
  autocmd!
augroup END


" Set autocmd
"
autocmd BufRead *.md    :set ts=4 sw=4 ft=markdown
autocmd BufRead *.txt   :set ft=markdown ff=dos
autocmd FileType php    :set ts=4 sw=4
autocmd FileType go     :set ts=4 sw=4 noexpandtab
autocmd FileType vim    :set ts=4 sw=4
autocmd FileType nginx  :set ts=4 sw=4

" For Python
autocmd BufRead requirements*txt :set ft=text ff=unix

" Visual
"
syntax enable
set visualbell
set number
set ruler
set nowrap
set ambiwidth=single " double
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

" Set color
"
autocmd ColorScheme * highlight Normal ctermbg=none
autocmd ColorScheme * highlight EndOfBuffer ctermbg=none
set colorcolumn=80


" Change Leader key into a comma instead of a backslash
"
let g:mapleader=','


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


" for omnifunc
"
set pumheight=15
highlight Pmenu       ctermbg=darkgray
highlight PmenuSel    ctermbg=blue
highlight PmenuSbar   ctermbg=white
highlight TabLine     ctermbg=white
highlight TabLineSel  ctermbg=red
highlight TabLineFill ctermbg=white


" for PHP
"
let g:php_sql_query     = 1
let g:php_htmlInStrings = 1
let g:php_folding       = 0


" for ChangeLog
"
let g:changelog_username = "Tomohiro Taira <tomohiro.t@gmail.com>"


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

" vp doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()


" for neocomplete.vim
"   https://github.com/Shougo/neocomplete.vim
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1

" Plugin key-mappings.
inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  " return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags


" for vim-indent-guides
"   https://github.com/nathanaelkane/vim-indent-guides
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :highlight IndentGuidesOdd  ctermbg=235
autocmd VimEnter,Colorscheme * :highlight IndentGuidesEven ctermbg=235


" for NERDCommenter
"   https://github.com/scrooloose/nerdcommenter
"   http://qiita.com/items/b69b41ad4ea2497b3477
let g:NERDSpaceDelims = 1
nmap <Leader>c <Plug>NERDCommenterToggle
vmap <Leader>c <Plug>NERDCommenterToggle


" for EasyMotion
"   https://github.com/Lokaltog/vim-easymotion/
"   http://blog.remora.cx/2012/08/vim-easymotion.html
let g:EasyMotion_keys='hjklasdfgyuiopqwertnmzxcvbHJKLASDFGYUIOPQWERTNMZXCVB' " Use home position keys


" for vim-airline
"   https://github.com/vim-airline/vim-airline/
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1

" for vim-airline-themes
"   https://github.com/vim-airline/vim-airline-themes
"   https://github.com/vim-airline/vim-airline/wiki/Screenshots
let g:airline_theme='minimalist'

" for Vim colorscheme
"   https://github.com/joshdick/onedark.vim
colorscheme onedark
