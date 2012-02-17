" Vim Bundle Plugin Manager: NeoBundle
" see https://github.com/Shougo/neobundle.vim
set nocompatible               " be iMproved
filetype plugin indent off     " required!

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
  call neobundle#rc(expand('~/.vim/bundle/'))
endif
" let NeoBundle manage NeoBundle
" required!
NeoBundle 'Shougo/neobundle.vim'

" Unite
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'

" Completion and snippets
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'ujihisa/neco-look'
NeoBundle 'msanders/snipmate.vim'

" Editing
NeoBundle 'Align'
"NeoBundle 'gtags.vim'
NeoBundle 't9md/vim-textmanip'
NeoBundle 'mattn/zencoding-vim'
NeoBundle 'h1mesuke/vim-alignta'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'nathanaelkane/vim-indent-guides'

" Version Control System
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'mattn/gist-vim'

" Tools
NeoBundle 'thinca/vim-ref'
NeoBundle 'fuenor/qfixhowm'

" Theme
NeoBundle 'ciaranm/inkpot'

" Buffer management
NeoBundle 'fholgado/minibufexpl.vim'

" Statusline
NeoBundle 'Lokaltog/vim-powerline'

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
set statusline=[%n]%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%m%r%w%=%{fugitive#statusline()}\ %l/%L:%c%V\ %3p%%

syntax on
filetype plugin indent on

highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=black
match ZenkakuSpace /　/

" for Vim Keybinding Customize
"
    nnoremap j gj
    nnoremap k gk
    imap jj <ESC>


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
    autocmd BufRead *.md    :set ft=markdown
    autocmd BufRead *.mkdn  :set ft=markdown
    autocmd BufRead *.mkd   :set ft=markdown
    autocmd BufRead *.ihtml :set ft=php
    autocmd BufRead *.txt   :set ft=markdown ff=dos
    autocmd FileType php    :set makeprg=php\ -l\ % errorformat=%m\ in\ %f\ on\ line\ %l 
    autocmd FileType php    :set dictionary=$HOME/.vim/dictionary/php.dict
    autocmd FileType ruby   :set ts=2 sw=2 fenc=utf-8
    autocmd FileType yaml   :set fenc=utf-8
    autocmd FileType css    :set fenc=utf-8


" for omnifunc Settings
"
    set pumheight=15
    hi Pmenu       ctermbg=darkgray
    hi PmenuSel    ctermbg=blue
    hi PmenuSbar   ctermbg=white
    hi TabLine     ctermbg=white
    hi TabLineSel  ctermbg=red
    hi TabLineFill ctermbg=white


" for PHP Settings
"
    let php_sql_query     = 1
    let php_htmlInStrings = 1
    let php_folding       = 0

" for ChangeLog
"
    let g:changelog_username = "Tomohiro <tomohiro@occ.co.jp>"


" for VimFiler
"
    let g:vimfiler_safe_mode_by_default=0


" for unite
"
    nnoremap <silent> <C-u>b :<C-u>Unite buffer<CR>
    nnoremap <silent> <C-u>f :VimFilerSplit<CR>
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
    vmap <C-j> <Plug>(textmanip-move-down)
    vmap <C-k> <Plug>(textmanip-move-up)
    vmap <C-h> <Plug>(textmanip-move-left)
    vmap <C-l> <Plug>(textmanip-move-right)

    vmap <M-d> <Plug>(textmanip-duplicate-down)
    nmap <M-d> <Plug>(textmanip-duplicate-down)


" for vim-ref
"
    let g:ref_phpmanual_path = $HOME . '/.vim/manual/php'


" for neocomplcache.vim
"
    let g:neocomplcache_enable_at_startup = 1
    let g:neocomplcache_enable_smart_case = 1
    let g:neocomplcache_enable_underbar_completion = 1


" for vim-indent-guides
"
"
    let g:indent_guides_enable_on_vim_startup=1
    let g:indent_guides_start_level=2
    let g:indent_guides_guide_size=1
    let g:indent_guides_auto_colors = 0
    autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=235
    autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=235


" for zencoding.vim
"
    let g:user_zen_expandabbr_key = '<c-e>'
    let g:user_zen_settings = {'indentation' : '    '}


" for vim-powerline
"
    if $KERNEL == 'Linux' && $SSH_CLIENT == ''
        let g:Powerline_symbols = 'fancy'
    endif

" for gtags.vim
"
    nnoremap <silent> <C-g>  :Gtags -g
    nnoremap <silent> <C-g>f :Gtags -f %<CR>
    nnoremap <silent> <C-g>r :Gtags -r <CR>
    nnoremap <silent> <C-g>j :GtagsCursor<CR>
    nnoremap <silent> <C-n>  :cn<CR>
    nnoremap <silent> <C-p>  :cp<CR>
    nnoremap <silent> <C-g>q <C-w><C-w><C-w>q


" for QFixHowm
"
    let QFixHowm_Key = 'g'
    let howm_dir = '~/Dropbox/howm/'
    let howm_filename = '%Y/%m/%Y-%m-%d-%H%M%S.markdown'
    let howm_fileencoding = 'utf-8'
    let howm_fileformat = 'unix'

    " Setting autoformat
    " see https://sites.google.com/site/fudist/Home/qfixhowm/option#auto-format
    let QFixHowm_Autoformat = 1
    let QFixHowm_Autoformat_TitleMode = 1
    let QFixHowm_SaveTime = -1

    " Setting markdown
    " see https://sites.google.com/site/fudist/Home/qfixhowm/tips/vimwiki
    let QFixHowm_FileType = 'markdown'
    let QFixHowm_Title = '#'
    let QFixHowm_Template = [
        \"%TITLE%",
        \"================================================================================",
        \"",
        \"",
        \"H2",
        \"--------------------------------------------------------------------------------",
        \"",
        \"",
        \"Reference",
        \"--------------------------------------------------------------------------------"
    \]
    let QFixHowm_Cmd_NewEntry = '$a'


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
