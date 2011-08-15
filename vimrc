" Vim Default Option:
"
set enc=utf-8
set fenc=utf-8
set fencs=utf-8,iso-2022-jp,euc-jp,cp932
set fileformats=unix,dos
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
set directory=/tmp//
set listchars=tab:>_,trail:_,eol:↩
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
set autoread
"set clipboard+=autoselect
"set clipboard+=unnamed

set laststatus=2
set statusline=%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%F%m%r%w%=<%3p%%><%4lL/%4LL:%02cC>

syntax on
filetype plugin indent on

highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=black
match ZenkakuSpace /　/

" for Vim Keybinding Customize
"
    nnoremap j gj
    nnoremap k gk


" remove highlight
"
    nmap <ESC><ESC> :nohlsearch<CR><ESC>


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

    nnoremap <SID>(split-to-j) :<C-u>execute 'belowright' (v:count == 0 ? '' : v:count) 'split'<CR>
    nnoremap <SID>(split-to-k) :<C-u>execute 'aboveleft'  (v:count == 0 ? '' : v:count) 'split'<CR>
    nnoremap <SID>(split-to-h) :<C-u>execute 'topleft'    (v:count == 0 ? '' : v:count) 'vsplit'<CR>
    nnoremap <SID>(split-to-l) :<C-u>execute 'botright'   (v:count == 0 ? '' : v:count) 'vsplit'<CR>


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


" for FileType Settings
"
    autocmd BufRead *.ihtml :set ft=php
    autocmd FileType php    :set makeprg=php\ -l\ % errorformat=%m\ in\ %f\ on\ line\ %l 
    autocmd FileType php    :set dictionary=$HOME/.vim/dictionary/php.dict
    autocmd FileType ruby   :set ts=2 sw=2 fenc=utf-8
    autocmd FileType yaml   :set fenc=utf-8
    autocmd FileType css    :set fenc=utf-8


" for omnifunc Settings
"
    set pumheight=15
    hi Pmenu ctermbg=darkgray
    hi PmenuSel ctermbg=blue
    hi PmenuSbar ctermbg=white
    hi TabLine ctermbg=white
    hi TabLineSel ctermbg=red
    hi TabLineFill ctermbg=white


" for PHP Settings
"
    let php_sql_query     = 1
    let php_htmlInStrings = 1
    let php_folding       = 0


" Vim Bundle Plugin Manager: Vundle
"
set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
"
Bundle 'gmarik/vundle'

" original repos on github
"
Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/unite.vim'
Bundle 'ciaranm/inkpot'
Bundle 'h1mesuke/unite-outline'
Bundle 'janne/markdown.vim'
Bundle 'mattn/googletranslate-vim'
Bundle 'mattn/zencoding-vim'
Bundle 'msanders/snipmate.vim'
Bundle 'skammer/vim-css-color'
Bundle 'thinca/vim-ref'
Bundle 'tpope/vim-surround'
Bundle 't9md/vim-textmanip'
Bundle 'jceb/vim-orgmode'
Bundle 'fuenor/qfixhowm'

" vim-scripts repos
"
Bundle 'gtags.vim'
Bundle 'coffee.vim'
Bundle 'rails.vim'

" non github repos
"
"Bundle 'git://git.wincent.com/command-t.git'

" for unite
"
    nnoremap <silent> <C-u>b :<C-u>Unite buffer<CR>
    nnoremap <silent> <C-u>o :<C-u>Unite outline<CR>
    nnoremap <silent> <C-u>f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
    nnoremap <silent> <C-u>r :<C-u>Unite -buffer-name=register register<CR>
    nnoremap <silent> <C-u>m :<C-u>Unite file_mru<CR>
    nnoremap <silent> <C-u>u :<C-u>Unite buffer file_mru<CR>
    nnoremap <silent> <C-u>a :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
    au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
    au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
    au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
    au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')


" for vim-textmanip
"
    vmap <C-j> <Plug>(Textmanip.move_selection_down)
    vmap <C-k> <Plug>(Textmanip.move_selection_up)
    vmap <C-h> <Plug>(Textmanip.move_selection_left)
    vmap <C-l> <Plug>(Textmanip.move_selection_right)

    vmap <M-d> <Plug>(Textmanip.duplicate_selection_v)
    nmap <M-d> <Plug>(Textmanip.duplicate_selection_n)


" for vim-ref
"
    "let g:ref_phpmanual_path = $HOME . '/.vim/manual/php'


" for neocomplcache.vim
"
    let g:neocomplcache_enable_at_startup = 1
    let g:neocomplcache_enable_smart_case = 1
    let g:neocomplcache_enable_underbar_completion = 1


" for zencoding.vim
"
    let g:user_zen_expandabbr_key = '<c-e>'
    let g:user_zen_settings = {'indentation' : '    '}


" for gtags.vim
"
    map <C-g>  :Gtags -g 
    map <C-g>f :Gtags -f %<CR>
    map <C-g>r :Gtags -r <CR>
    map <C-g>j :GtagsCursor<CR>
    map <C-n>  :cn<CR>
    map <C-p>  :cp<CR>
    map <C-g>q <C-w><C-w><C-w>q


" for Vim colorscheme settings
"
    if filereadable($HOME . '/.vim/bundle/inkpot/colors/inkpot.vim')
        colorscheme inkpot
    else
        colorscheme desert
        set background=dark
    endif


" Override colorscheme settings
"
    hi LineNr     ctermbg=235 ctermfg=105
    hi StatusLine ctermbg=64  ctermfg=15
