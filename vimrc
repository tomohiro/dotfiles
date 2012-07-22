" NeoBundle is Vim plugin manager based on Vundle(https://github.com/gmarik/vundle).
"   [Shougo/neobundle.vim](https://github.com/Shougo/neobundle.vim)
"
set nocompatible               " be iMproved
filetype plugin indent off     " required!

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
  call neobundle#rc(expand('~/.vim/bundle/'))
endif

" let NeoBundle manage NeoBundle
" required!
NeoBundle 'Shougo/neobundle.vim'

" Tagbar [Tagbar, the Vim class outline viewer](http://majutsushi.github.com/tagbar/)
NeoBundle 'majutsushi/tagbar'
NeoBundle 'techlivezheng/tagbar-phpctags'
NeoBundle 'techlivezheng/phpctags'

" Unite
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'

" Completion and snippets
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'ujihisa/neco-look'
NeoBundle 'msanders/snipmate.vim'

" Editing
NeoBundle 'Align'
NeoBundle 'h1mesuke/vim-alignta'
NeoBundle 't9md/vim-textmanip'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'Townk/vim-autoclose'
NeoBundle 'mattn/zencoding-vim'
NeoBundle 'kchmck/vim-coffee-script'

" Version Control System
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'mattn/gist-vim'

" Ruby on Rails
NeoBundle 'tpope/vim-rails'

" Redmine
NeoBundle 'basyura/unite-yarm'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'tyru/open-browser.vim'

" Tools
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'fuenor/qfixhowm'
NeoBundle 'kien/ctrlp.vim'

" Themes
NeoBundle 'ciaranm/inkpot'

" Buffer management
NeoBundle 'fholgado/minibufexpl.vim'

" Tab management
NeoBundle 'kana/vim-tabpagecd'  "http://labs.timedia.co.jp/2012/05/vim-tabpagecd.html

" Statusline
NeoBundle 'Lokaltog/vim-powerline'
NeoBundle 'pwdstatus.vim'


" Encoding
"
    set encoding=utf-8
    set fileencoding=utf-8
    set fileencodings=utf-8,iso-2022-jp,euc-jp,cp932
    set fileformats=unix,dos

" Vim Default Option:
"
set complete+=k
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set wildmenu
set viminfo=
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
    syntax on
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
    set foldcolumn=1
    set foldmethod=marker


"set laststatus=2
"set statusline=[%n]%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%m%r%w%=%{fugitive#statusline()}\ %l/%L:%c%V\ %3p%%

filetype plugin on
filetype indent on


" Change Leader key into a comma instead of a backslash
"
    let mapleader=','


" Reload configuration
"
    nnoremap <silent> <Leader>s :source $HOME/.vimrc<CR>


" for Vim Keybinding Customize
"
    nnoremap j gj
    nnoremap k gk
    imap jj <ESC>


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
    autocmd BufRead *.md    :set ft=markdown
    autocmd BufRead *.mkdn  :set ft=markdown
    autocmd BufRead *.mkd   :set ft=markdown
    autocmd BufRead *.ihtml :set ft=php
    autocmd BufRead *.txt   :set ft=markdown ff=dos
    autocmd FileType php    :set makeprg=php\ -l\ % errorformat=%m\ in\ %f\ on\ line\ %l 
    autocmd FileType php    :set dictionary=$HOME/.vim/dictionary/php.dict
    autocmd FileType ruby   :set ts=2 sw=2 fenc=utf-8
    autocmd FileType sh     :set ts=2 sw=2
    autocmd FileType bash   :set ts=2 sw=2
    autocmd FileType yaml   :set fenc=utf-8
    autocmd FileType css    :set fenc=utf-8


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
    let g:changelog_username = "Tomohiro <tomohiro@occ.co.jp>"


" for toggle line numbers
"
    function! NumberToggle()
        (&relativenumber == 1)
            set number
        else
            set relativenumber
        endif
    endfunc
    nnoremap <silent> <Leader>n :call NumberToggle()<CR>


" for VimFiler
"
    let g:vimfiler_safe_mode_by_default=0
    nnoremap <silent> <Leader>f :VimFiler -buffer-name=explorer -split -winwidth=40 -toggle -no-quit<CR>


" for unite
"
    nnoremap <silent> <Leader>ub :Unite buffer<CR>
    nnoremap <silent> <Leader>ur :Unite -buffer-name=register register<CR>
    nnoremap <silent> <Leader>um :Unite file_mru<CR>
    nnoremap <silent> <Leader>uu :Unite buffer file_mru<CR>
    nnoremap <silent> <Leader>ua :UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
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
    let g:Powerline_symbols = 'fancy'
    call Pl#Theme#InsertSegment('ws_marker', 'after', 'lineinfo')


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


" for Tagbar
"   [Tagbar, the Vim class outline viewer](http://majutsushi.github.com/tagbar/)
"   [techlivezheng/tagbar-phpctags](https://github.com/techlivezheng/tagbar-phpctags)
"   [techlivezheng/phpctags](https://github.com/techlivezheng/phpctags)
"
    nnoremap <silent> <Leader>t :TagbarToggle<CR>
    let g:tagbar_phpctags_bin = $HOME . '/.vim/bundle/phpctags/phpctags'


" for ctrlp.vim
"   [ctrlp.vim ÷ home](http://kien.github.com/ctrlp.vim/)
"
    set wildignore+=*/tmp/*,*.so,*.swp,*.zip,tar.gz,tgz  " MacOSX/Linux

    let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'


" for Vim colorscheme
"
    if filereadable($HOME . '/.vim/bundle/inkpot/colors/inkpot.vim')
        colorscheme inkpot
    else
        colorscheme desert
        set background=dark
    endif


" Override colorscheme
"
    hi LineNr     ctermbg=235 ctermfg=105
    hi StatusLine ctermbg=64  ctermfg=15
    hi clear CursorLine
    hi CursorLine gui=underline
    hi CursorLine ctermbg=235 guibg=235
