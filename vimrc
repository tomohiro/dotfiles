" VIM-PLUG A minimalist Vim plugin manager
"   https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

" Modern default configuration
Plug 'tpope/vim-sensible'

" Editing Support
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdcommenter'        " Intensely orgasmic commenting
Plug 'bronson/vim-trailing-whitespace' " Highlights trailing whitespace
Plug 'vim-syntastic/syntastic'

" Completion
Plug 'Shougo/neocomplete'

" Appearance
Plug 'nathanaelkane/vim-indent-guides' " Change bgcolor for indent
Plug 'mhinz/vim-signify'               " Show git diff status on each line
Plug 'ryanoasis/vim-devicons'

" Themes
Plug 'joshdick/onedark.vim'

" Statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes' " airline theme collection
Plug 'cocopon/iceberg.vim'            " iceberg theme for airline

" Syntax highlight
Plug 'chr4/nginx.vim'

call plug#end()

" Vim Default Option
"
set complete+=k
set tabstop=2
set shiftwidth=2
set expandtab
set hlsearch
set iminsert=0
set imsearch=0
set ignorecase
set smartcase
set incsearch
set wrapscan
set ww=31
set autoread

" Set directory for backups, swaps, undo history
"
set backupdir=${XDG_CACHE_HOME}/vim/backup,/tmp
set directory=${XDG_CACHE_HOME}/vim/swap,/tmp
set undodir=${XDG_CACHE_HOME}/vim/undo,/tmp
set viminfo+=n${XDG_CACHE_HOME}/vim/viminfo

" Visual
"
set ambiwidth=double
set ttyfast
set visualbell
set number
set nowrap
set breakindent
set showcmd
set showmatch
set list
set listchars=tab:>_,trail:_,extends:>,precedes:<,nbsp:+,eol:↩
set cursorline
set colorcolumn=80

" Set color
"
augroup custom_color
  autocmd!
  autocmd ColorScheme * highlight Normal ctermbg=none
  autocmd ColorScheme * highlight EndOfBuffer ctermbg=none
augroup END

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

" Remove highlight
"
nnoremap <silent> <Leader>c :nohlsearch<CR>

" Don't create .vim/.netrwhist
"   https://vim-jp.org/vimdoc-ja/pi_netrw.html#g:netrw_dirhistmax
let g:netrw_dirhistmax=0

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
augroup vim_indent_guides
  autocmd!
  autocmd VimEnter,Colorscheme * :highlight IndentGuidesOdd  ctermbg=235
  autocmd VimEnter,Colorscheme * :highlight IndentGuidesEven ctermbg=235
augroup END

" for NERDCommenter
"   https://github.com/scrooloose/nerdcommenter
"   http://qiita.com/items/b69b41ad4ea2497b3477
let g:NERDSpaceDelims = 1
nmap <Leader>c <Plug>NERDCommenterToggle
vmap <Leader>c <Plug>NERDCommenterToggle


" for vim-airline
"   https://github.com/vim-airline/vim-airline/
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1
" Set symbols from nerd fonts
"   https://nerdfonts.com/
"   https://github.com/ryanoasis/powerline-extra-symbols
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = "\ue0b8"
let g:airline_left_alt_sep = "\ue0b1"
let g:airline_right_sep = "\ue0ba"
let g:airline_right_alt_sep = "\ue0bb"
" Override section
let g:airline_section_a = airline#section#create_left(["\ue7c5", 'mode'])


" for vim-airline-themes
"   https://github.com/vim-airline/vim-airline-themes
"   https://github.com/vim-airline/vim-airline/wiki/Screenshots
"   https://github.com/cocopon/iceberg.vim
let g:airline_theme='iceberg'


" for vim-devicons
"   https://github.com/ryanoasis/vim-devicons
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1


" for Vim colorscheme
"   https://github.com/joshdick/onedark.vim
colorscheme onedark
