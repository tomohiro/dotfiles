" Vim Bundle Plugin: Vundle
"

set rtp+=~/.vim/vundle/
call vundle#rc()

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
Bundle 'thinca/vim-ref'
Bundle 'tpope/vim-surround'

" vim-scripts repos
"
Bundle 'gtags.vim'
Bundle 'coffee.vim'
Bundle 'rails.vim'

" non github repos
"
"Bundle 'git://git.wincent.com/command-t.git'

"filetype off
"filetype plugin indent on


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
set directory=/tmp/
set listchars=tab:>_,trail:_,eol:↲
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

" for TeX Keybinding
"
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

" for clifox Keybinding
"map <C-r> :silent !clifox -h 172.16.5.222 -r <Enter>

" for Vim 7 omnifunc Settings
"
if v:version >= 700
    set pumheight=15
    hi Pmenu ctermbg=darkgray
    hi PmenuSel ctermbg=blue
    hi PmenuSbar ctermbg=white
    hi TabLine ctermbg=white
    hi TabLineSel ctermbg=red
    hi TabLineFill ctermbg=white

    map <F6> gT
endif

" for PHP Settings
"
let php_sql_query     = 1
let php_htmlInStrings = 1
let php_folding       = 0

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

" for gtags.vim
"
map <C-g>  :Gtags -g 
map <C-g>f :Gtags -f %<CR>
map <C-g>r :Gtags -r <CR>
map <C-g>j :GtagsCursor<CR>
map <C-n>  :cn<CR>
map <C-p>  :cp<CR>
map <C-g>q <C-w><C-w><C-w>q

" for QFixHowm
"
set runtimepath+=~/.vim/qfixapp

let howm_suffix           = 'markdown'
let my_blog_draft_dir     = 'Development/tomohiro.heroku.com/_draft'

let QFixHowm_HowmMode      = 0
let QFixHowm_UserFileType  = 'markdown'
let QFixHowm_UserFileExt   = howm_suffix
let QFixHowm_QuickMemoFile = 'Qmem-00-0000-00-00-00000.' . howm_suffix
let QFixHowm_Title         = '#'
let QFixHowm_Key           = 'g'

let howm_dir          = $HOME . '/' . my_blog_draft_dir
let howm_filename     = '%Y-%m-%d-%H%M%S.' . howm_suffix
let howm_fileencoding = 'utf-8'
let howm_fileformat   = 'unix'

let QFixHowm_Template_mkd = [
  \"%TITLE% %TAG%",
  \""
\]
let QFixHowm_Cmd_NewEntry_mkd = '$a'

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
