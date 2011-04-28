"=============================================================================
"    Description: HowmTitlelist for QFixHowm
"         Author: fuenor <fuenor@gmail.com>
"  Last Modified: 2011-03-08 18:38
"        Version: 1.06
"=============================================================================
scriptencoding utf-8

if exists('loaded_HowmFiles') && !exists('fudist')
  finish
endif
let loaded_HowmFiles=1

if v:version < 700
  finish
endif

let s:howmsuffix = 'howm'
if !exists('howm_filename')
  let howm_filename     = '%Y/%m/%Y-%m-%d-%H%M%S.'.s:howmsuffix
endif

if !exists('g:HowmFiles_Sort')
  let g:HowmFiles_Sort = ''
endif

if !exists('g:QFixHowm_MenuCloseOnJump')
  let g:QFixHowm_MenuCloseOnJump = 1
endif
if !exists('g:QFixHowm_MenuHeight')
  let g:QFixHowm_MenuHeight = 0
endif
if !exists('g:QFixHowm_MenuPreview')
  let g:QFixHowm_MenuPreview = 1
endif
if !exists('g:HowmFiles_Preview')
  let g:HowmFiles_Preview = 1
endif

let s:howmsuffix = 'howm'
let s:filehead = 'howm://'

""""""""""""""""""""""""""""""
" 高速リスト一覧
""""""""""""""""""""""""""""""
augroup HowmFiles
  au!
  autocmd BufWinEnter __Howm_Files__ call <SID>BufWinEnter(g:QFix_PreviewEnable)
  " autocmd BufEnter    __Howm_Files__ set winfixheight
  autocmd BufLeave    __Howm_Files__ call <SID>BufLeave()
  autocmd CursorHold  __Howm_Files__ call <SID>Preview()

  autocmd BufWinEnter __HOWM_MENU__ call <SID>BufWinEnterMenu(g:HowmFiles_Preview, s:filehead)
  " autocmd BufEnter    __HOWM_MENU__ set winfixheight
  autocmd BufLeave    __HOWM_MENU__ call <SID>BufLeaveMenu()
  autocmd CursorHold  __HOWM_MENU__ call <SID>PreviewMenu(s:filehead)
augroup END

function! s:BufWinEnter(preview)
  setlocal winfixheight
  let b:updatetime = g:QFix_PreviewUpdatetime
  exec 'setlocal updatetime='.b:updatetime
  let b:PreviewEnable = a:preview

  call QFixAltWincmdMap()
  nnoremap <buffer> <silent> q :<C-u>call <SID>Close()<CR>
  nnoremap <buffer> <silent> <CR> :<C-u>call <SID>CR()<CR>

  nnoremap <buffer> <silent> i :<C-u>call <SID>TogglePreview()<CR>
  nnoremap <buffer> <silent> I :<C-u>call <SID>TogglePreview()<CR>
  nnoremap <buffer> <silent> D :call <SID>Exec('delete','Delete')<CR>
  nnoremap <buffer> <silent> R :call <SID>Exec('delete','Remove')<CR>
  vnoremap <buffer> <silent> D :call <SID>Exec('delete','Delete')<CR>
  vnoremap <buffer> <silent> R :call <SID>Exec('delete','Remove')<CR>
  nnoremap <buffer> <silent> S :<C-u>call <SID>SortExec()<CR>
  nnoremap <buffer> <silent> s :<C-u>call <SID>Search('g!')<CR>
  nnoremap <buffer> <silent> r :<C-u>call <SID>Search('g')<CR>
  nnoremap <buffer> <silent> dd :call <SID>Exec('delete')<CR>
  vnoremap <buffer> <silent> d :call <SID>Exec('delete')<CR>
  nnoremap <buffer> <silent> p :<C-u>call <SID>Exec('put')<CR>
  nnoremap <buffer> <silent> P :<C-u>call <SID>Exec('put!')<CR>
  nnoremap <buffer> <silent> u :<C-u>call <SID>Exec('undo')<CR>
  nnoremap <buffer> <silent> <C-r> :<C-u>call <SID>Exec("redo")<CR>

  nnoremap <buffer> <silent> A :HowmFilesWriteResult<CR>
  silent! nnoremap <buffer> <unique> <silent> o :HowmFilesWriteResult<CR>
  nnoremap <buffer> <silent> O :HowmFilesReadResult<CR>

  syn match	qfFileName	"^[^|]*" nextgroup=qfSeparator
  syn match	qfSeparator	"|" nextgroup=qfLineNr contained
  syn match	qfLineNr	"[^|]*" contained contains=qfError
  syn match	qfError		"error" contained

  " The default highlighting.
  hi def link qfFileName	Directory
  hi def link qfLineNr	LineNr
  hi def link qfError	Error

  silent exec 'lchdir ' . escape(g:howm_dir, ' ')
endfunction

function! s:BufLeave()
  " set nowinfixheight
  let s:lnum = line('.')
  if b:PreviewEnable
    call QFixPclose()
  endif
endfunction

function! s:Preview()
  if b:PreviewEnable < 1
    return
  endif

  let [file, lnum] = s:Getfile('.')
  call QFixPreviewOpen(file, lnum)
endfunction

function! s:TogglePreview(...)
  let b:PreviewEnable = !b:PreviewEnable
  if a:0
    " let g:QFixHowm_MenuPreview = b:PreviewEnable
  else
    let g:HowmFiles_Preview = b:PreviewEnable
  endif
  if !b:PreviewEnable
    call QFixPclose()
  endif
endfunction

function! s:CR()
  let [file, lnum] = s:Getfile('.')
  if !filereadable(file)
    call QFixHowmActionLock()
    return
  endif
  call QFixEditFile(file)
  call cursor(lnum, 1)
  exec 'normal! zz'
endfunction

function! s:Close()
  if winnr('$') == 1 || (winnr('$') == 2 && b:PreviewEnable == 1)
    if tabpagenr('$') > 1
      tabclose
    else
      silent! b #
      " silent! close
    endif
  else
    close
  endif
endfunction

function! s:Getfile(lnum, ...)
  let l = a:lnum
  let str = getline(l)
  if a:0
    let head = a:1
    if str !~ '^'.head
      return ['', 0]
    endif
    let str = substitute(str, '^'.head, '', '')
  endif
  let file = substitute(str, '|.*$', '', '')
  silent exec 'lchdir ' . escape(g:howm_dir, ' ')
  let file = fnamemodify(file, ':p')
  if !filereadable(file)
    return ['', 0]
  endif
  let lnum = matchstr(str, '|\d\+\( col \d\+\)\?|')
  let lnum = matchstr(lnum, '\d\+')
  if lnum == ''
    let lnum = 1
  endif
  let file = substitute(file, '\\', '/', 'g')
  return [file, lnum]
endfunction

function! s:Search(cmd, ...)
  if a:0
    let _key = a:1
  else
    let mes = a:cmd == 'g' ? '(exclude)' : ''
    let _key = input('Search for pattern'.mes.' : ')
    if _key == ''
      return
    endif
  endif
  let @/=_key
  call s:Exec(a:cmd.'/'._key.'/d')
  call cursor(1, 1)
endfunction

function! s:SortExec(...)
  let mes = 'Sort type? (r:reverse)+(m:mtime, n:name, t:text, h:howmtime) : '
  if a:0
    let pattern = a:1
  else
    let pattern = input(mes, '')
  endif
  if pattern =~ 'r\?m'
    let g:QFix_Sort = substitute(pattern, 'm', 'mtime', '')
  elseif pattern =~ 'r\?n'
    let g:QFix_Sort = substitute(pattern, 'n', 'name', '')
  elseif pattern =~ 'r\?t'
    let g:QFix_Sort = substitute(pattern, 't', 'text', '')
  elseif pattern =~ 'r\?h'
    let g:QFix_Sort = substitute(pattern, 'h', 'howmtime', '')
  elseif pattern == 'r'
    let g:QFix_Sort = 'reverse'
  else
    return
  endif

  echo 'HowmFiles : Sorting...'
  let sq = []
  for n in range(1, line('$'))
    let [pfile, lnum] = s:Getfile(n)
    let text = substitute(getline(n), '[^|].*|[^|].*|', '', '')
    let mtime = getftime(pfile)
    let sepdat = {"filename":pfile, "lnum": lnum, "text":text, "mtime":mtime, "bufnr":-1}
    call add(sq, sepdat)
  endfor

  if g:QFix_Sort =~ 'howmtime'
    let sq = QFixHowmSort('howmtime', 0, sq)
    if pattern =~ 'r.*'
      let sq = reverse(sq)
    endif
    let g:QFix_Sort = 'howmtime'
  elseif g:QFix_Sort =~ 'mtime'
    let sq = s:Sort(g:QFix_Sort, sq)
  elseif g:QFix_Sort =~ 'name'
    let sq = s:Sort(g:QFix_Sort, sq)
  elseif g:QFix_Sort =~ 'text'
    let sq = s:Sort(g:QFix_Sort, sq)
  elseif g:QFix_Sort == 'reverse'
    let sq = reverse(sq)
  endif
  silent exec 'lchdir ' . escape(g:howm_dir, ' ')
  let s:glist = []
  for d in sq
    let filename = fnamemodify(d['filename'], ':.')
    let line = printf("%s|%d| %s", filename, d['lnum'], d['text'])
    call add(s:glist, line)
  endfor
  setlocal modifiable
  silent! %delete _
  call setline(1, s:glist)
  setlocal nomodifiable
  call cursor(1,1)
  redraw|echo 'Sorted by '.g:QFix_Sort.'.'
endfunction

function! s:Sort(cmd, sq)
  if a:cmd =~ 'mtime'
    let sq = sort(a:sq, "s:QFixCompareTime")
  elseif a:cmd =~ 'name'
    let sq = sort(a:sq, "s:QFixCompareName")
  elseif a:cmd =~ 'text'
    let sq = sort(a:sq, "s:QFixCompareText")
  endif
  if g:QFix_Sort =~ 'r.*'
    let sq = reverse(a:sq)
  endif
  let g:QFix_SearchResult = []
  return sq
endfunction

function! s:QFixCompareName(v1, v2)
  if a:v1.filename == a:v2.filename
    return (a:v1.lnum > a:v2.lnum?1:-1)
  endif
  return ((a:v1.filename) . a:v1.lnum> (a:v2.filename) . a:v2.lnum?1:-1)
endfunction

function! s:QFixCompareTime(v1, v2)
  if a:v1.mtime == a:v2.mtime
    if a:v1.filename != a:v2.filename
      return (a:v1.filename < a:v2.filename?1:-1)
    endif
    return (a:v1.lnum > a:v2.lnum?1:-1)
  endif
  return (a:v1.mtime < a:v2.mtime?1:-1)
endfunction

function! s:QFixCompareText(v1, v2)
  if a:v1.text == a:v2.text
    return (a:v1.filename < a:v2.filename?1:-1)
  endif
  return (a:v1.text > a:v2.text?1:-1)
endfunction

function! s:Cmd_RD(cmd, fline, lline)
  let [file, lnum] = s:Getfile(a:fline)
  if a:cmd == 'Delete'
    let mes = "!!! Delete file(s) !!!"
  elseif a:cmd == 'Remove'
    let mes = "!!! Remove to (".g:howm_dir.")"
  else
    return 0
  endif
  let choice = confirm(mes, "&Yes\n&Cancel", 2, "W")
  if choice != 1
    return 0
  endif
  for lnum in range(a:fline, a:lline)
    let [file, lnum] = s:Getfile(lnum)
    let dst = expand(g:howm_dir).'/'.fnamemodify(file, ':t')
    if a:cmd == 'Delete'
      call delete(file)
    elseif a:cmd == 'Remove'
      echoe 'Remove' fnamemodify(file, ':t')
      call rename(file, dst)
    endif
  endfor
  return 1
endfunction

function! s:Exec(cmd, ...) range
  let cmd = a:cmd
  if a:firstline != a:lastline
    let cmd = a:firstline.','.a:lastline.cmd
  endif
  if a:0
    if s:Cmd_RD(a:1, a:firstline, a:lastline) != 1
      return
    endif
  endif
  let mod = &modifiable ? '' : 'no'
  setlocal modifiable
  exec cmd
  exec 'setlocal '.mod.'modifiable'
endfunction

""""""""""""""""""""""""""""""
"メニュー画面
""""""""""""""""""""""""""""""
"メニューファイルディレクトリ
if !exists('g:QFixHowm_MenuDir')
  let g:QFixHowm_MenuDir = ''
endif
"メニューファイル名
if !exists('g:QFixHowm_Menufile')
  let g:QFixHowm_Menufile = 'Menu-00-00-000000.'.s:howmsuffix
endif
" メニュー画面に表示する MRUリストのエントリ数
if !exists('g:QFixHowm_MenuRecent')
  let g:QFixHowm_MenuRecent = 5
endif

command! -count -nargs=* QFixHowmOpenMenuCache         call QFixHowmOpenMenu('cache')
command! -count -nargs=* QFixHowmOpenMenu              call QFixHowmOpenMenu()

let s:menubufnr = 0
function! QFixHowmOpenMenu(...)
  if QFixHowmInit()
    return
  endif
  if count > 0
    let g:QFixHowm_ShowScheduleMenu = count
  endif
  redraw | echo 'QFixHowm : Open menu...'
  let winnr = QFixWinnr()
  exec winnr.'wincmd w'
  if &buftype == 'quickfix'
    silent! wincmd w
  endif
  let g:QFix_Disable = 1
  silent! let firstwin = s:GetBufferInfo()
  if g:QFixHowm_MenuDir== ''
    let mfile = g:howm_dir. '/'.g:QFixHowm_Menufile
  else
    let mfile = g:QFixHowm_MenuDir  . '/' . g:QFixHowm_Menufile
  endif
  let mfile = fnamemodify(mfile, ':p')
  let mfile = substitute(mfile, '\\', '/', 'g')
  let mfile = substitute(mfile, '/\+', '/', 'g')
  let mfilename = '__HOWM_MENU__'

  if !filereadable(mfile)
    let dir = fnamemodify(mfile, ':h')
    if isdirectory(dir) == 0 && dir != ''
      call mkdir(dir, 'p')
    endif
    let from = &enc
    let to   = g:howm_fileencoding
    call map(g:QFixHowmMenuList, 'iconv(v:val, from, to)')
    call writefile(g:QFixHowmMenuList, mfile)
  endif
  let glist = QFixHowmReadfile(mfile)
  let use_reminder = count(glist, '%reminder')
  let from = g:howm_fileencoding
  let to   = &enc
  call map(g:QFixHowmMenuList, 'iconv(v:val, from, to)')

  let recent = QFixMRUGetList(g:howm_dir, g:QFixHowm_MenuRecent)
  let reminder = []
  if use_reminder
    let saved_ull = g:QFix_UseLocationList
    let g:QFix_UseLocationList = 1
    if a:0
      let reminder = QFixHowmListReminderCache("menu")
    else
      let reminder = QFixHowmListReminder("menu")
    endif
    let g:QFix_UseLocationList = saved_ull
  endif
  let random = QFixHowmRandomWalk(g:howm_random_columns)
  let menubuf = 0
  for i in range(1, winnr('$'))
    if fnamemodify(bufname(winbufnr(i)), ':t') == mfilename
      exec i . 'wincmd w'
      let menubuf = i
      let g:HowmMenuLnum = getpos('.')
      break
    endif
  endfor
  if s:menubufnr
    exec 'b '.s:menubufnr
  else
    silent! exec 'silent! edit '.mfilename
    let s:menubufnr = bufnr('%')
  endif
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal nobuflisted
  setlocal modifiable
  exec 'setlocal fenc='.g:howm_fileencoding
  exec 'setlocal ff='.g:howm_fileformat
  if g:QFixHowm_MenuHeight > 0
    exec 'resize '. g:QFixHowm_MenuHeight
  endif
  silent! %delete _
  silent! exec 'silent! -1put=glist'
  silent! $delete _
  exec 'lchdir ' . escape(g:howm_dir, ' ')
  call cursor(1,1)
  if search('%menu%', 'cW') > 0
    let str = substitute(getline('.'), '%menu%', mfile, '')
    call setline(line('.'), str)
  endif
  call cursor(1, 1)
  call s:HowmMenuReplace(reminder, '^\s*%reminder')
  call s:HowmMenuReplace(recent, '^\s*%recent')
  call s:HowmMenuReplace(random, '^\s*%random')
  call setpos('.', g:HowmMenuLnum)
  if exists("*QFixHowmOpenMenuPost")
    call QFixHowmOpenMenuPost()
  endif
  setlocal nomodifiable
  if firstwin
    enew
    b #
  endif
  let g:QFix_Disable = 0
endfunction

let s:first = 0
function! s:GetBufferInfo()
  if s:first
    return 0
  endif
  redir => bufoutput
  buffers
  redir END
  for buf in split(bufoutput, '\n')
    let bits = split(buf, '"')
    let b = {"attributes": bits[0], "line": substitute(bits[2], '\s*', '', '')}
    if bits[0] !~ '^\s*1\s' || bits[0] =~ '^\s*1\s*#'
      let s:first = 1
      return 0
    endif
  endfor
  return 1
endfunction

function! s:HowmMenuReplace(sq, rep, ...)
  let glist = []
  for d in a:sq
    if exists('d["filename"]')
      let file = d['filename']
    else
      let file = bufname(d['bufnr'])
    endif
    let file = fnamemodify(file, ':.')
    let file = 'howm://'.file
    call add(glist, printf("%s|%d| %s", file, d['lnum'], d['text']))
  endfor
  if a:0
    let from = a:1
    let to   = &enc
    call map(glist, 'iconv(v:val, from, to)')
  endif
  let save_cursor = getpos('.')
  call cursor(1,1)
  if search(a:rep, 'cW') > 0
    silent! delete _
    silent! exec 'silent! -1put=glist'
  endif
  call setpos('.', save_cursor)
endfunction

silent! function HowmMenuCmd_()
  call HowmMenuCmdMap(',')
  call HowmMenuCmdMap('r,')
  call HowmMenuCmdMap('I', 'H')
  call HowmMenuCmdMap('.', 'c')
  call HowmMenuCmdMap('u')
  call HowmMenuCmdMap('<Space>', ' ')
  call HowmMenuCmdMap('m')
  call HowmMenuCmdMap('o', 'l')
  call HowmMenuCmdMap('O', 'L')
  call HowmMenuCmdMap('A')
  call HowmMenuCmdMap('a')
  call HowmMenuCmdMap('ra')
  call HowmMenuCmdMap('s')
  call HowmMenuCmdMap('S', 'g')
  call HowmMenuCmdMap('<Tab>', 'y')
  call HowmMenuCmdMap('t')
  call HowmMenuCmdMap('ry')
  call HowmMenuCmdMap('rt')
  call HowmMenuCmdMap('rr')
  call HowmMenuCmdMap('rk')
  call HowmMenuCmdMap('rR')
  call HowmMenuCmdMap('rN')
  call HowmMenuCmdMap('rA')
  call HowmMenuCmdMap('R', 'rA')
endfunction

function! HowmMenuCmdMap(cmd, ...)
  let cmd = a:0 ? a:1 : a:cmd
  let cmd = ':call QFixHowmCmd("'.cmd.'")<CR>'
  if g:QFixHowm_MenuCloseOnJump && cmd =~ '"[cu ]"'
    let cmd = cmd.':<C-u>call HowmMenuClose()<CR>'
  endif
  exec 'silent! nnoremap <buffer> <silent> '.a:cmd.' '.cmd
endfunction

function! HowmMenuCR() range
  let save_cursor = getpos('.')
  if count
    call cursor(count, 1)
  endif
  call search('[^\s]', 'cb', line('.'))
  call search('[^\s]', 'cw', line('.'))
  let [lnum, fcol] = searchpos('%', 'ncb', line('.'))
  let [lnum, lcol] = searchpos(']', 'ncw', line('.'))
  let cmd = strpart(getline('.'), fcol, (lcol-fcol))
  let dcmd = matchstr(cmd, '"\s"\[[^ ]\+\]')
  if dcmd != ''
    let cmd = dcmd
  else
    let cmd = substitute(cmd, '\s\+.*$', '', '')
    let cmd = matchstr(cmd, '"[^ ]\+"\[[^ ]\+\]')
  endif
  if cmd != ''
    let cmd = substitute(matchstr(cmd, '".\+"'), '^"\|"$', '', 'g')
    if cmd =~ '^<.*>$'
      exec 'let cmd = '.'"\'.cmd.'"'
    endif
    call feedkeys(cmd, 't')
    call setpos('.', save_cursor)
    return ''
  endif
  let [file, lnum] = s:Getfile('.', s:filehead)
  if !filereadable(file)
    call QFixHowmActionLock()
    return ''
  endif
  if g:QFixHowm_MenuCloseOnJump
    " set nowinfixheight
    exec 'edit '.escape(file, ' %#')
  else
    call QFixEditFile(file)
  endif
  call cursor(lnum, 1)
  exec 'normal! zz'
  return ''
endfunction

function! HowmMenuClose()
  if winnr('$') == 1 || (winnr('$') == 2 && g:QFix_Win > 0)
    exec 'silent! b#'
    return
  endif
  let mfilename = '__HOWM_MENU__'
  for i in range(1, winnr('$'))
    if fnamemodify(bufname(winbufnr(i)), ':t') == mfilename
      exec i . 'wincmd w'
      exec 'silent! close'
    endif
  endfor
endfunction

function! s:BufWinEnterMenu(preview, head)
  " setlocal winfixheight
  let b:updatetime = g:QFix_PreviewUpdatetime
  exec 'setlocal updatetime='.b:updatetime
  if !exists('b:PreviewEnable')
    let b:PreviewEnable = a:preview
  endif

  hi def link QFMenuButton	Special
  hi def link QFMenuSButton	Identifier
  exec 'set ft='.g:QFixHowm_FileType
  syn region QFMenuSButton start=+%"\zs+ end=+[^"]\+\ze"\[+ end='$'
  syn region QFMenuButton start=+"\[\zs+ end=+[^\]]\+\ze\(\s\|]\)+ end='$'
  exec 'syn match	mqfFileName	"^'.a:head.'[^|]*"'.' nextgroup=qfSeparator'
  syn match	qfSeparator	"|" nextgroup=qfLineNr contained
  syn match	qfLineNr	"[^|]*" contained contains=qfError
  syn match	qfError		"error" contained

  hi def link mqfFileName	Directory
  hi def link qfLineNr	LineNr
  hi def link qfError	Error
  call QFixHowmQFsyntax()

  nnoremap <buffer> <silent> q :<C-u>call <SID>Close()<CR>
  nnoremap <buffer> <silent> i :<C-u>call <SID>TogglePreview('menu')<CR>
  call QFixAltWincmdMap()
  nnoremap <buffer> <silent> <CR> :<C-u>call HowmMenuCR()<CR>
  nnoremap <buffer> <silent> <2-LeftMouse> <ESC>:<C-u>call HowmMenuCR()<CR>
  call HowmMenuCmd_()
  silent! call HowmMenuCmd()

  silent exec 'lchdir ' . escape(g:howm_dir, ' ')
endfunction

let g:HowmMenuLnum = [0, 1, 1, 0]
function! s:BufLeaveMenu()
  " set nowinfixheight
  let g:HowmMenuLnum = getpos('.')
  if b:PreviewEnable
    call QFixPclose()
  endif
endfunction

function! s:PreviewMenu(head)
  if b:PreviewEnable < 1
    return
  endif
  let [file, lnum] = s:Getfile('.', a:head)
  if file == ''
    call QFixPclose()
    return
  endif
  call QFixPreviewOpen(file, lnum)
endfunction

""""""""""""""""""""""""""""""
" タイトルリスト
""""""""""""""""""""""""""""""
let g:HowmFilesMode = 0
let s:lnum = 1
function! QFixHowmListAllTitleAlt(...)
  let g:HowmFilesMode = 0
  let mode = (a:0 && a:1 == 'Diary')
  QFixCclose
  let defsort = 0
  if !exists('s:glist') || a:0
    let defsort = 1
    let pattern = QFixHowmGetTitleGrepRegxp()
    let addflag = 0
    redraw|echo 'HowmFiles : Searching...'
    let prevPath = escape(getcwd(), ' ')
    silent exec 'lchdir ' . escape(g:howm_dir, ' ')
    call MyGrep(pattern, g:howm_dir, g:QFixHowm_SearchHowmFile, g:howm_fileencoding, addflag, 'noqfix')
    if !exists('g:mygrepprg') || g:mygrepprg == 'internal' || g:mygrepprg == ''
      let s:glist = []
      let qflist = QFixGetqflist()
      for n in qflist
        let bufnum = n['bufnr']
        let filename = fnamemodify(bufname(bufnum), ':.')
        let line = printf("%s|%d| %s", filename, n['lnum'], n['text'])
        call add(s:glist, line)
      endfor
    else
      let s:glist = []
      for n in g:MyGrep_qflist
        " let n['filename'] = g:howm_dir . '/' . n['filename']
        if mode && (n['filename'] !~ g:QFixHowm_SearchDiaryFile)
          continue
        endif
        let line = printf("%s|%d| %s", n['filename'], n['lnum'], n['text'])
        call add(s:glist, line)
      endfor
      let s:glist = reverse(s:glist)
    endif
    silent exec 'lchdir ' . prevPath
    if mode
      let defsort = 0
    endif
    if mode && len(s:glist) == 0
      redraw|echo 'HowmFiles : Not found!'
      return
    endif
    let s:lnum = 1
  endif

  let file = g:howm_dir.'/__Howm_Files__'
  let mode = 'split'
  call QFixEditFile(file, mode)
  silent exec 'lchdir ' . escape(g:howm_dir, ' ')
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal nobuflisted
  setlocal nowrap
  setlocal cursorline
  " setlocal winfixheight
  wincmd J

  setlocal modifiable
  silent! %delete _
  if s:glist == [] && mode == 0
    silent! 0put=g:MyGrep_retval
    silent! %s/:\(\d\+\):/|\1|/
    silent! $delete _
  else
    call setline(1, s:glist)
  endif
  call cursor(s:lnum, 1)
  if exists("*QFixHowmListAllTitleAltPost")
    call QFixHowmListAllTitleAltPost()
  endif
  setlocal nomodifiable

  silent exec 'lchdir ' . escape(g:howm_dir, ' ')
  let g:QFix_SearchPath = g:howm_dir
  if defsort && g:HowmFiles_Sort != ''
    call s:SortExec(g:HowmFiles_Sort)
  endif
  nnoremap <buffer> <silent> i :<C-u>call <SID>TogglePreview()<CR>
endfunction

function! SetHowmFiles(glist, ...)
  let path = g:howm_dir
  let file = g:howm_dir.'/__Howm_Files__'
  let mode = 'split'
  call QFixEditFile(file, mode)
  silent exec 'lchdir ' . escape(g:howm_dir, ' ')
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal nobuflisted
  setlocal nowrap
  setlocal cursorline
  " setlocal winfixheight
  wincmd J

  let glist = []
  for n in a:glist
    let file = substitute(n, '|.*$', '', '')
    let file = fnamemodify(file, ':.')
    let n = substitute(n, '^[^|]\+|', '', '')
    let n = file. '|'.n
    call add(glist, n)
  endfor

  setlocal modifiable
  silent! %delete _
  call setline(1, glist)
  " setlocal nomodifiable

  silent exec 'lchdir ' . escape(g:howm_dir, ' ')
  let g:QFix_SearchPath = g:howm_dir
endfunction

command! -count -nargs=* -bang HowmFilesReadResult call HowmFilesReadResult()
function! HowmFilesReadResult()
  let file = expand(g:MyGrep_Resultfile)
  if count
    let file = substitute(file, '\(\.[^.]\+$\)', count.'\1', '')
  endif
  let mod = &modifiable ? '' : 'no'
  setlocal modifiable
  let result = readfile(file)
  call remove(result, 0)
  silent exec 'lchdir ' . escape(g:howm_dir, ' ')
  let glist=[]
  for n in result
    let fname = substitute(n, '|.*$', '', '')
    let fname = fnamemodify(fname, ':.')
    let n = substitute(n, '^[^|]\+|', '', '')
    let n = fname. '|'.n
    call add(glist, n)
  endfor
  silent! %delete _
  silent! 0put=glist
  silent! $delete _
  exec 'setlocal '.mod.'modifiable'
  call cursor(1, 1)
  redraw|echo 'HowmFiles : ReadResult "'.file.'"'
endfunction

command! -nargs=* -bang -count HowmFilesWriteResult call HowmFilesWriteResult(<bang>0, <q-args>)
function! HowmFilesWriteResult(mode, file) range
  let file = expand(g:MyGrep_Resultfile)
  if count
    let file = substitute(file, '\(\.[^.]\+$\)', count.'\1', '')
  endif
  if a:file != ''
    let file = expand(a:file)
  endif
  let firstline = 1
  let cnt = line('$')-1
  let result = []
  call add(result, expand(g:howm_dir). '|'.line('.').'|')
  for d in range(firstline, firstline+cnt)
    let text = getline(d)
    if text == ''
      continue
    endif
    let fname = substitute(text, '|.*$', '', '')
    let fname = fnamemodify(fname, ':p')
    let text = fname . matchstr(text, '|.*')
    let result = add(result, text)
  endfor
  call writefile(result, file)
  redraw|echo 'HowmFiles : WriteResult "'.file.'"'
endfunction

""""""""""""""""""""""""""""""
" メニューウィンドウをQuickfixからの<CR>で選択可能にする
""""""""""""""""""""""""""""""
let s:bufnr = -1
function! QFixCR(mode)
  let type = a:mode == 'before' ? '' : 'nofile'
  if type != '' && s:bufnr > -1
    let i = winnr()
    split
    exec 'b '. s:bufnr
    exec 'setlocal buftype='.type
    close
    exec i . 'wincmd w'
    return
  endif
  let s:bufnr = -1
  for i in range(1, winnr('$'))
    if fnamemodify(bufname(winbufnr(i)), ':t') == '__HOWM_MENU__'
      let s:bufnr = winbufnr(i)
      exec i . 'wincmd w'
      exec 'setlocal buftype='.type
       wincmd p
      return
    endif
  endfor
endfunction

""""""""""""""""""""""""""""""
" ファイルリネーム
""""""""""""""""""""""""""""""
" ファイル名をタイトル行から生成したファイル名へ変更する場合の文字数
if !exists('g:QFixHowm_FilenameLen')
  let g:QFixHowm_FilenameLen = len(fnamemodify(strftime(g:howm_filename), ':t:r'))
endif
" 対象外にする正規表現
if !exists('g:QFixHowm_RenameAllExcludeRegxp')
  let g:QFixHowm_RenameAllExcludeRegxp = ''
endif

function! QFixHowmRename_(...)
  if QFixHowmInit()
    return
  endif
  let from = fnamemodify(expand('%:p'), ':p')
  let fname = ''
  let l:QFixHowm_Title = QFixHowmGetTitleSearchRegxp()
  if a:0
    let fname = a:1
  else
    let lnum = search(l:QFixHowm_Title, 'ncbW')
    if lnum != 0
      let fname = substitute(getline(lnum), l:QFixHowm_Title . '\s*\|\.\+$', '', 'g')
      if IsQFixHowmFile(fnamemodify(from, ':p'))
        let fname = QFixHowmFormatFileName(fname)
      endif
    endif
  endif
  let file = fname
  if file == ''
    let file = fnamemodify(from, ':t:r')
  endif
  while 1
    if fname == ''
      let fname = fnamemodify(from, ':t:r')
      let fname = input('Rename to : ', file)
    endif
    if fname == ''
      return
    endif
    let fname = fname.'.'.fnamemodify(from, ':e')
    let choice = 0
    if filereadable(fnamemodify(from, ':p:h') . '/'.fname)
      let mes = '"'.fname.'" already exists.'
      let choice = confirm(mes, "&Input name\n&Overwrite\n&Cancel", 1, "Q")
      if choice == 1
        let fname = ''
        continue
      elseif choice != 2
        return
      endif
    endif
    if choice == 0
      let mes = 'Rename to "'.fname.'"'
      let choice = confirm(mes, "&OK\n&Input name\n&Cancel", 1, "Q")
      if choice == 2
        let fname = ''
        continue
      elseif choice != 1
        return
      endif
    endif
    break
  endwhile
  let to = fnamemodify(from, ':p:h') . '/'.fname
  update
  call rename(from, to)
  silent! exec 'silent! edit '.escape(fname, ' %#')
  silent! exec 'silent! bwipeout '.from
endfunction

function! QFixHowmFormatFileName(fname, ...)
  let l:QFixHowm_Title = QFixHowmGetTitleSearchRegxp()
  let fname = a:fname

  let fname = substitute(fname, l:QFixHowm_Title . '\s*\|\.\+$', '', 'g')
  let fname = substitute(fname, '^\(\[[^\]]\+\]\s*\)\+', '', 'g')
  let chars = g:QFixHowm_FilenameLen
  if a:0
    let chars = a:chars
  endif
  let fn =  chars != 0 ? '' : fname
  while chars
    let ch = matchstr(fname, '.')
    if ch == ''
      break
    endif
    let fn = fn.ch
    let len = len(ch)
    let fname = strpart(fname, len)
    let chars -= len > 1 ? 2 : 1
    if fname == '' || chars < 1
      break
    endif
  endwhile
  let fn = substitute(fn, '[/:*?"<>|\\]', '_', 'g')
  return fn
endfunction

command! -bang -nargs=? QFixHowmRenameAll call QFixHowmRenameAll(<q-args>, <bang>0)
function! QFixHowmRenameAll(...)
  if QFixHowmInit()
    return
  endif
  redraw|echo 'Howmfiles : Searching...'
  let file = '**/*'
  if a:0 && a:1 != ''
    let list = QFixHowmFileList(a:1, file, 'List')
  else
    let list = QFixHowmFileListMultiDir(file, 'List')
  endif

  let hfile = fnamemodify(g:howm_filename, ':t:r')

  let hfile = substitute(hfile, '%Y', '\\d\\{4}', '')
  let hfile = substitute(hfile, '%m', '\\d\\{2}', '')
  let hfile = substitute(hfile, '%d', '\\d\\{2}', '')
  let hfile = substitute(hfile, '%H', '\\d\\{2}', '')
  let hfile = substitute(hfile, '%M', '\\d\\{2}', '')
  let hfile = substitute(hfile, '%S', '\\d\\{2}', '')

  let hfile = hfile.'.\('.s:howmsuffix.'\|'.g:QFixHowm_FileExt.'\)'
  let l:QFixHowm_Title = QFixHowmGetTitleSearchRegxp()

  let glist = []

  let exreg = g:QFixHowm_SearchDiaryFile
  let exreg = substitute(exreg, '^\*\*/', '', '')
  let exreg = substitute(exreg, '\.', '\.', 'g')
  let exreg = substitute(exreg, '\*', '.*', 'g')
  let exreg = substitute(exreg, '?', '.', 'g')
  let exreg = '\('.exreg.'\|000000\)'
  let uexreg = g:QFixHowm_RenameAllExcludeRegxp
  let uexreg = uexreg == '' ? '^$' : uexreg
  for d in list
    let from = d['filename']
    if d['text'] !~ l:QFixHowm_Title
      continue
    endif
    if fnamemodify(from, ':t') !~ hfile
      continue
    endif
    if from =~ exreg.'\|'.'[/\\]'.g:QFixHowm_PairLinkDir .'[/\\]'
      continue
    endif
    if from =~ uexreg
      continue
    endif
    let fname = QFixHowmFormatFileName(d['text'])
    let head = substitute(expand(g:howm_dir), '\', '/', 'g')
    let from = substitute(from, '^'.head.'.', '', '')
    call add(glist, printf("%s|%d| %s", from, 1, fname.'.'.fnamemodify(from, ':e')))
  endfor
  call SetHowmFiles(glist)
  let g:HowmFilesMode = 1
  silent! unmap <buffer> i
  nnoremap <silent> <buffer> !     :<C-u>call QFixHowmRenameAll_()<CR>
  nnoremap <silent> <buffer> <C-g> :<C-u>call QFixHowmRenameAll_()<CR>
  redraw| echo ' <C-g> or ! : Rename all files.'
endfunction

function! QFixHowmRenameAll_()
  let mes = '!!! Rename all howm files.'
  if confirm(mes, "&OK\n&Cancel", 2, "W") != 1
    return
  endif
  let glist = []
  for n in range(1, line('$'))
    let str = getline(n)
    let from = substitute(str, '|.*$', '', '')
    let from = fnamemodify(from, ':p')
    let to = substitute(str, '^.*|\s*', '', '')
    let to = fnamemodify(from, ':p:h') . '/' . to
    if filereadable(to)
      call add(glist, str)
      continue
    endif
    call rename(from, to)
  endfor
  if len(glist)
    call SetHowmFiles(glist)
    redraw|echo 'Please, change these filename(s).'
  else
    silent! %delete _
    close
    redraw|echo 'Done.'
  endif
endfunction

function! QFixHowmFileListMultiDir(file, ...)
  let basename    = 'g:howm_dir'
  let tlist =  QFixHowmGetFileList(g:howm_dir, a:file)
  call QFixHowmFLaddtitle(g:howm_dir, tlist)
  for i in range(2, g:QFixHowm_howm_dir_Max)
    if g:QFixHowm_howm_dir_Max < 2
      break
    endif
    if !exists(basename.i)
      continue
    endif
    exec 'let hdir = '.basename.i
    let hdir = expand(hdir)
    if isdirectory(hdir) == 0
      continue
    endif
    let l:howm_fileencoding = g:howm_fileencoding
    if exists('g:howm_fileencoding'.i)
      exec 'let l:howm_fileencoding = g:howm_fileencoding'.i
    endif
    if l:howm_fileencoding != g:howm_fileencoding
      let g:QFixHowm_ForceEncoding = 0
    endif
    let list = QFixHowmGetFileList(hdir, a:file)
    call QFixHowmFLaddtitle(hdir, list)
    let tlist = extend(tlist, list)
  endfor
  let cnt = g:QFixHowm_FileListMax
  if count
    let cnt = count
  endif
  if cnt
    silent! call remove(tlist, cnt, -1)
  endif
  if a:0
    return tlist
  endif
  call s:QFixHowmShowFileList(g:howm_dir, tlist)
endfunction

"ファイルリストをquickfixに登録
function! s:QFixHowmShowFileList(path, list)
  if QFixHowmInit()
    return
  endif
  let prevPath = escape(getcwd(), ' ')
  let g:QFix_SelectedLine = 1
  let g:QFix_SearchResult = []
  let g:QFix_SearchPath = a:path
  QFixCclose
  call QFixSetqflist(a:list)
  QFixCopen
endfunction
