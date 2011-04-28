"=============================================================================
"    Description: 拡張Quickfixに対応したhowm
"         Author: fuenor <fuenor@gmail.com>
"                 http://sites.google.com/site/fudist/Home/qfixhowm
"  Last Modified: 2011-04-22 09:36
"        Version: 2.46
"=============================================================================
scriptencoding utf-8
"キーマップリーダーが g の場合、「新規ファイルを作成」は g,c です。
"簡単な使い方はg,Hのヘルプで、詳しい使い方は以下のサイトを参照してください。
"http://sites.google.com/site/fudist/Home/qfixhowm
"
"----------以下は変更しないで下さい----------
"
"=============================================================================
"    Description: howmスタイルの予定・TODOを表示 (要mygrep.vim)
"                 ここから loaded_HowmScheduleまで実行すれば単独で使用可能
"                 (let g:HowmSchedule_only = 1)
"                 :call QFixHowmSchedule('schedule', dir, fileencoding)
"                 :call QFixHowmSchedule('todo',     dir, fileencoding)
"                 最低限 howm_dir, howm_fileencodingが設定されていれば動作する。
"                 | g,y  | 予定             |
"                 | g,ry | 予定(更新)       |
"                 | g,t  | Todo             |
"                 | g,rt | Todo(更新)       |
"                 | g,d  | 日付の挿入       |
"                 | g,T  | 日付と時刻の挿入 |
"                 | g,rd | 繰り返しの展開   |
"                 ・syntax表示には howm_schedule.vimをリネームして使用する。
"                 ・<CR>にアクションロックが必要な場合はキーをマップする
"                   nnoremap <silent> <buffer> <CR> :call QFixHowmUserModeCR(...)<CR>
"  Last Modified: 0000-00-00 00:00
"=============================================================================
let s:Version = 1.00
if exists('disable_MyGrep') && disable_MyGrep == 1
  finish
endif
if exists('disable_HowmSchedule') && disable_HowmSchedule
  finish
endif
if exists('g:QFixHowmSchedule_version') && g:QFixHowmSchedule_version < s:Version
  unlet loaded_HowmSchedule
endif
if exists("loaded_HowmSchedule") && !exists('fudist')
  finish
endif
if v:version < 700 || &cp || !has('quickfix')
  finish
endif
let g:QFixHowmSchedule_version = s:Version

let s:debug = 0
if exists('g:fudist') && g:fudist
  let s:debug = 1
endif

""""""""""""""""""""""""""""""
" howmスタイル予定・TODO表示コマンド
" call QFixHowmSchedule('schedule', 'c:/temp', 'utf-8')
" type : 'schedule' or 'todo'
""""""""""""""""""""""""""""""
function! QFixHowmSchedule(type, dir, fenc, ...)
  let l:howm_dir          = g:howm_dir
  let l:howm_fileencoding = g:howm_fileencoding
  let g:howm_dir          = a:dir
  let g:howm_fileencoding = a:fenc
  call s:QFixHowmListReminder_(a:type)
  let g:howm_dir          = l:howm_dir
  let g:howm_fileencoding = l:howm_fileencoding
endfunction

""""""""""""""""""""""""""""""
let s:howmsuffix = 'howm'
if !exists('howm_dir')
  let howm_dir          = '~/howm'
endif
if !exists('howm_filename')
  let howm_filename     = '%Y/%m/%Y-%m-%d-%H%M%S.'.s:howmsuffix
endif
if !exists('howm_fileencoding')
  let howm_fileencoding = &enc
endif
if !exists('howm_fileformat')
  let howm_fileformat   = &ff
endif

"キーマップリーダー
if !exists('g:QFixHowm_Key')
  if exists('g:howm_mapleader')
    let g:QFixHowm_Key = howm_mapleader
  else
    let g:QFixHowm_Key = 'g'
  endif
endif
"2ストローク目キーマップ
if !exists('g:QFixHowm_KeyB')
  let g:QFixHowm_KeyB = ','
endif
"キーマップを使用する
if !exists('g:QFixHowm_Default_Key')
  let g:QFixHowm_Default_Key = 1
endif
"メニューへの登録
if !exists('QFixHowm_MenuBar')
  let QFixHowm_MenuBar = 2
endif

"正規表現パーツ
if !exists('g:QFixHowm_DatePattern')
  let g:QFixHowm_DatePattern = '%Y-%m-%d'
endif

"予定・TODOを検索するルートディレクトリ
if !exists('g:QFixHowm_ScheduleSearchDir')
  let g:QFixHowm_ScheduleSearchDir = ''
endif
"予定・TODOを検索するファイル
if !exists('g:QFixHowm_ScheduleSearchFile')
  let g:QFixHowm_ScheduleSearchFile = ''
endif
"予定・TODOを検索する時vimgrepを使用する
if !exists('g:QFixHowm_ScheduleSearchVimgrep')
  let g:QFixHowm_ScheduleSearchVimgrep = 0
endif

"休日定義ファイル
if !exists('g:QFixHowm_HolidayFile')
  let g:QFixHowm_HolidayFile = 'Sche-Hd-0000-00-00-000000.*'
endif
"休日名
if !exists('g:QFixHowm_ReminderHolidayName')
  let g:QFixHowm_ReminderHolidayName = '元日\|成人の日\|建国記念の日\|昭和の日\|憲法記念日\|みどりの日\|こどもの日\|海の日\|敬老の日\|体育の日\|文化の日\|勤労感謝の日\|天皇誕生日\|春分の日\|秋分の日\|振替休日\|国民の休日\|日曜日'
endif

"予定やTODOのデフォルト値
if !exists('g:QFixHowm_ReminderDefault_Deadline')
  let g:QFixHowm_ReminderDefault_Deadline = 7
endif
if !exists('g:QFixHowm_ReminderDefault_Schedule')
  let g:QFixHowm_ReminderDefault_Schedule = 0
endif
if !exists('g:QFixHowm_ReminderDefault_Reminder')
  let g:QFixHowm_ReminderDefault_Reminder = 1
endif
if !exists('g:QFixHowm_ReminderDefault_Todo')
  let g:QFixHowm_ReminderDefault_Todo     = 7
endif
if !exists('g:QFixHowm_ReminderDefault_UD')
  let g:QFixHowm_ReminderDefault_UD       = 30
endif

",y の予定表示日数
if !exists('g:QFixHowm_ShowSchedule')
  let g:QFixHowm_ShowSchedule     = 10
endif
",t の予定表示日数
if !exists('g:QFixHowm_ShowScheduleTodo')
  let g:QFixHowm_ShowScheduleTodo = -1
endif
",,の予定表示日数
if !exists('g:QFixHowm_ShowScheduleMenu')
  let g:QFixHowm_ShowScheduleMenu = 10
endif
",y で表示する予定・TODO
if !exists('g:QFixHowm_ListReminder_ScheExt')
  let g:QFixHowm_ListReminder_ScheExt = '[@!.]'
endif
",t で表示する予定・TODO
if !exists('g:QFixHowm_ListReminder_TodoExt')
  let g:QFixHowm_ListReminder_TodoExt = '[-@+!~.]'
endif
"menuで表示する予定・TODO
if !exists('g:QFixHowm_ListReminder_MenuExt')
  let g:QFixHowm_ListReminder_MenuExt = '[-@+!~.]'
endif
"予定・TODOのキャッシュを保持する時間
if !exists('g:QFixHowm_ListReminderCacheTime')
  let g:QFixHowm_ListReminderCacheTime = 5*60
endif

"予定・TODOのソート優先順
if !exists('g:QFixHowm_ReminderPriority')
  let g:QFixHowm_ReminderPriority = {'@' : 1, '!' : 2, '+' : 3, '-' : 4, '~' : 5, '.' : 6}
endif
"予定・TODOの同一日、同一種類のソート正順/逆順
if !exists('g:QFixHowm_ReminderSortMode')
  let g:QFixHowm_ReminderSortMode = 1
endif
"今日の時刻の扱い
if !exists('g:QFixHowm_TodayLineType')
  let g:QFixHowm_TodayLineType = '@'
endif
"同一日、同一内容の予定・TODOは一つにまとめる
if !exists('g:QFixHowm_RemoveSameSchedule')
  let g:QFixHowm_RemoveSameSchedule = 1
endif
"予定を表示する際、曜日も表示する
if !exists('g:QFixHowm_ShowScheduleDayOfWeek')
  let g:QFixHowm_ShowScheduleDayOfWeek = 1
endif
"予定・TODOに今日の日付を表示
if !exists('g:QFixHowm_ShowTodayLine')
  let g:QFixHowm_ShowTodayLine = 3
endif
"予定・TODOの今日の日付表示用セパレータ
if !exists('g:QFixHowm_ShowTodayLineStr')
  let g:QFixHowm_ShowTodayLineStr = '------------------------------'
endif
"予定・TODOの今日の日付表示のファイルネーム
if !exists('g:QFixHowm_TodayFname')
  let g:QFixHowm_TodayFname = '='
endif

"予定・TODOでプレビュー表示を有効にする
if !exists('g:QFixHowm_SchedulePreview')
  let g:QFixHowm_SchedulePreview = 1
endif
"予定やTodoのプライオリティレベルが、これ未満のエントリは削除する
if !exists('g:QFixHowm_RemovePriority')
  let g:QFixHowm_RemovePriority = 1
endif
"予定やTodoのプライオリティレベルが、今日よりこれ以下なら削除する。
if !exists('g:QFixHowm_RemovePriorityDays')
  let g:QFixHowm_RemovePriorityDays = 0
endif
"リマインダの継続期間のオフセット
if !exists('g:QFixHowm_ReminderOffset')
  let g:QFixHowm_ReminderOffset = 0
endif
"終了日指定のオフセット
if !exists('g:QFixHowm_EndDateOffset')
  let g:QFixHowm_EndDateOffset = 0
endif

"strftime()の基準年
if !exists('g:YearStrftime')
  let g:YearStrftime = 1970
endif
"strftime()の基準日数
if !exists('g:DateStrftime')
  let g:DateStrftime = 719162
endif
"GMTとの時差
if !exists('g:QFixHowm_ST')
  let g:QFixHowm_ST = -9
endif

"タイトルフィルタ用正規表現
if !exists('g:QFixHowm_TitleFilterReg')
  let g:QFixHowm_TitleFilterReg = ''
endif

if g:QFixHowm_Default_Key > 0
  let s:QFixHowm_Key = g:QFixHowm_Key . g:QFixHowm_KeyB
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'t     :<C-u>call QFixHowmListReminderCache("todo")<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'rt    :<C-u>call QFixHowmListReminder("todo")<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'y     :<C-u>call QFixHowmListReminderCache("schedule")<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'<Tab> :<C-u>call QFixHowmListReminderCache("schedule")<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'ry    :<C-u>call QFixHowmListReminder("schedule")<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'rd    :<C-u>call QFixHowmGenerateRepeatDate()<CR>'
  exec "silent! nnoremap <unique> <silent> ".s:QFixHowm_Key."d :call QFixHowmInsertDate('Date')<CR>"
  exec "silent! nnoremap <unique> <silent> ".s:QFixHowm_Key."T :call QFixHowmInsertDate('Time')<CR>"
endif

if QFixHowm_MenuBar && ((exists('HowmSchedule_only') && HowmSchedule_only == 1) || (exists('disable_MyHowm') && disable_MyHowm == 1))
  let s:menu = '&Tools.QFixHowm(&H)'
  if QFixHowm_MenuBar == 2
    let s:menu = 'Howm(&O)'
  elseif QFixHowm_MenuBar == 3 || MyGrep_MenuBar == 3
    let s:menu = 'QFixApp(&Q).QFixHowm(&H)'
  endif
  let s:QFixHowm_Key = escape(g:QFixHowm_Key . g:QFixHowm_KeyB, '\\')
  exec 'amenu <silent> 41.332 '.s:menu.'.Schedule(&Y)<Tab>'.s:QFixHowm_Key.'y  :<C-u>call QFixHowmListReminderCache("schedule")<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.Todo(&T)<Tab>'.s:QFixHowm_Key.'t  :<C-u>call QFixHowmListReminderCache("todo")<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.Rebuild-Schedule(&I)<Tab>'.s:QFixHowm_Key.'ry  :<C-u>call QFixHowmListReminder("schedule")<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.Rebuild-Todo(&K)<Tab>'.s:QFixHowm_Key.'rt  :<C-u>call QFixHowmListReminder("todo")<CR>'
  let s:QFixHowm_Key = g:QFixHowm_Key . g:QFixHowm_KeyB
endif

""""""""""""""""""""""""""""""
" commands
""""""""""""""""""""""""""""""
" ShowReminder commands
command! -count -nargs=* QFixHowmListReminderSche      call QFixHowmListReminder("schedule")
command! -count -nargs=* QFixHowmListReminderTodo      call QFixHowmListReminder("todo")
command! -count -nargs=* QFixHowmListReminderScheCache call QFixHowmListReminderCache("schedule")
command! -count -nargs=* QFixHowmListReminderTodoCache call QFixHowmListReminderCache("todo")

function! s:makeRegxp(dpattern)
  let s:hts_date     = a:dpattern
  let s:hts_time     = '%H:%M'
  let s:hts_dateTime = s:hts_date . ' '. s:hts_time

  "let s:sch_date     = '\d\{4}-\d\{2}-\d\{2}'
  let s:sch_date = s:hts_date
  let s:sch_date = substitute(s:sch_date, '%Y', '\\d\\{4}', '')
  let s:sch_date = substitute(s:sch_date, '%m', '\\d\\{2}', '')
  let s:sch_date = substitute(s:sch_date, '%d', '\\d\\{2}', '')
  let g:QFixHowm_Date = s:sch_date

  let s:sch_printfDate = s:hts_date
  let s:sch_printfDate = substitute(s:sch_printfDate, '%Y', '%4.4d', '')
  let s:sch_printfDate = substitute(s:sch_printfDate, '%m', '%2.2d', '')
  let s:sch_printfDate = substitute(s:sch_printfDate, '%d', '%2.2d', '')

  let s:sch_ExtGrep = s:hts_date. ' ' . s:hts_time
  let s:sch_ExtGrep = substitute(s:sch_ExtGrep, '%Y', '[0-9]{4}', '')
  let s:sch_ExtGrep = substitute(s:sch_ExtGrep, '%m', '[0-9]{2}', '')
  let s:sch_ExtGrep = substitute(s:sch_ExtGrep, '%d', '[0-9]{2}', '')
  let s:sch_ExtGrep = substitute(s:sch_ExtGrep, '%H', '[0-9]{2}', '')
  let s:sch_ExtGrep = substitute(s:sch_ExtGrep, '%M', '[0-9]{2}', '')

  let s:sch_ExtGrepS = s:hts_date. '( ' . s:hts_time . ')?'
  let s:sch_ExtGrepS = substitute(s:sch_ExtGrepS, '%Y', '[0-9]{4}', '')
  let s:sch_ExtGrepS = substitute(s:sch_ExtGrepS, '%m', '[0-9]{2}', '')
  let s:sch_ExtGrepS = substitute(s:sch_ExtGrepS, '%d', '[0-9]{2}', '')
  let s:sch_ExtGrepS = substitute(s:sch_ExtGrepS, '%H', '[0-9]{2}', '')
  let s:sch_ExtGrepS = substitute(s:sch_ExtGrepS, '%M', '[0-9]{2}', '')

  "let s:sch_time     = '\d\{2}:\d\{2}'
  let s:sch_time = s:hts_time
  let s:sch_time = substitute(s:sch_time, '%H', '\\d\\{2}', '')
  let s:sch_time = substitute(s:sch_time, '%M', '\\d\\{2}', '')

  let s:sch_dateT    = '\['.s:sch_date.'\( '.s:sch_time.'\)\?\]'
  let s:sch_dateTime = '\['.s:sch_date.' '.s:sch_time.'\]'
  let s:sch_dow      = '\c\(\(Sun\|Mon\|Tue\|Wed\|Thu\|Fri\|Sat\|Hdy\)\)'
  let s:sch_ext      = '-@!+~.'
  let s:sch_Ext      = '['.s:sch_ext.']'
  let s:sch_notExt   = '[^'.s:sch_ext.']'
  let s:sch_dateCmd  = s:sch_dateT . s:sch_Ext . '\{1,3}\(([0-9]*[-+*]\?'.s:sch_dow.'\?)\)\?[0-9]*'
  let s:sch_cmd      = s:sch_Ext . '\{1,3}\(([0-9]*[-+*]\?'.s:sch_dow.'\?\([-+]\d\+\)\?)\)\?[0-9]*'
  let s:Recentmode_Date   = '(\d\{12})'
endfunction
call s:makeRegxp(g:QFixHowm_DatePattern)

let s:LT_schedule = 0
let s:sq_schedule = []
let s:LT_todo = 0
let s:sq_todo = []
let s:LT_menu = 0
let s:sq_menu = []

function! QFixHowmInsertDate(fmt)
  let fmt = s:hts_dateTime
  if a:fmt == 'Date'
    let fmt = s:hts_date
  endif
  let str = strftime('['.fmt.']')
  silent! put=str
  call cursor(line('.'), col('$'))
  startinsert
endfunction

function! QFixHowmListReminderCache(mode)
  if count > 0
    if a:mode =~ 'schedule'
      let g:QFixHowm_ShowSchedule = count
    elseif a:mode =~ 'todo'
      let g:QFixHowmListReminderTodo = count
    endif
  endif
  if exists('*QFixHowmInit') && QFixHowmInit()
    return
  endif
  exec 'let lt = localtime() - s:LT_' . a:mode
  if count
    let lt = g:QFixHowm_ListReminderCacheTime + 1
  endif
  if g:QFixHowm_ListReminderCacheTime > 0 && lt < g:QFixHowm_ListReminderCacheTime
    exec 'let sq = s:sq_' . a:mode
    if a:mode == 'menu'
      redraw|echo 'QFixHowm : Cached '.a:mode . '. ('.lt/60.' minutes ago)'
      return sq
    endif
    QFixCclose
    let l:howm_dir = g:howm_dir
    let g:QFix_SearchPath = l:howm_dir
    call QFixSetqflist(sq)
    QFixCopen
    call cursor(1, 1)
    redraw|echo 'QFixHowm : Cached '.a:mode . '. ('.lt/60.' minutes ago)'
    if g:QFixHowm_SchedulePreview == 0 && g:QFix_PreviewEnable == 1
      let g:QFix_PreviewEnable = -1
    endif
  else
    return QFixHowmListReminder(a:mode)
  endif
endfunction

function! QFixHowmListReminder(mode)
  if count > 0
    if a:mode =~ 'schedule'
      let g:QFixHowm_ShowSchedule = count
    elseif a:mode =~ 'todo'
      let g:QFixHowmListReminderTodo = count
    endif
  endif
  if exists('*QFixHowmInit') && QFixHowmInit()
    return
  endif
  if a:mode =~ 'menu'
    let saved_sq = getloclist(0)
  endif
  let sq = s:QFixHowmListReminder_(a:mode)
  if a:mode =~ 'menu'
    call setloclist(0, saved_sq)
  endif
  return sq
endfunction

function! s:QFixHowmListReminder_(mode)
  if exists('*QFixHowmInit') && QFixHowmInit()
    return
  endif
  let addflag = 0
  let l:howm_dir = g:howm_dir
  if g:QFixHowm_ScheduleSearchDir != ''
    let l:howm_dir = g:QFixHowm_ScheduleSearchDir
  endif
  let l:SearchFile = '**/*.*'
  silent! let l:SearchFile = g:QFixHowm_SearchHowmFile
  if g:QFixHowm_ScheduleSearchFile != ''
    let l:SearchFile = g:QFixHowm_ScheduleSearchFile
  endif
  let holiday_sq = s:HolidayVimgrep(l:howm_dir, g:QFixHowm_HolidayFile)
  QFixCclose
  let prevPath = escape(getcwd(), ' ')
  silent exec 'lchdir ' . escape(l:howm_dir, ' ')
  let ext = s:sch_Ext
  if a:mode =~ 'todo'
    let ext = g:QFixHowm_ListReminder_TodoExt
    if g:QFixHowm_ShowScheduleTodo < 0
      let ext = substitute(ext, '@', '', '')
    endif
  elseif a:mode =~ 'schedule'
    let ext = g:QFixHowm_ListReminder_ScheExt
    if g:QFixHowm_ShowSchedule < 0
      let ext = substitute(ext, '@', '', '')
    endif
  elseif a:mode =~ 'menu'
    let ext = g:QFixHowm_ListReminder_MenuExt
    if g:QFixHowm_ShowScheduleMenu < 0
      let ext = substitute(ext, '@', '', '')
    endif
  endif
  if g:QFixHowm_RemovePriority > -1
    let ext = substitute(ext, '\.', '', '')
  endif
  if !exists('g:mygrepprg') || g:mygrepprg == 'internal' || g:mygrepprg == '' || g:QFixHowm_ScheduleSearchVimgrep 
    let g:MyGrep_UseVimgrep = 1
    let searchWord = '^\s*'.s:sch_dateT.ext
  elseif g:mygrepprg == 'findstr'
    let searchWord = s:hts_date
    let searchWord = substitute(searchWord, '%Y', '[0-9][0-9][0-9][0-9]', '')
    let searchWord = substitute(searchWord, '%m', '[0-9][0-9]', '')
    let searchWord = substitute(searchWord, '%d', '[0-9][0-9]', '')
    let searchWord = '^[ \t]*\['.searchWord.'[0-9: ]*\]'.ext
  else
    let searchWord = '^[ \t]*\['.s:sch_ExtGrepS.']'.ext
  endif
  let searchPath = l:howm_dir
  if exists('*MultiHowmDirGrep')
    if g:QFixHowm_ScheduleSearchDir == ''
      let addflag = MultiHowmDirGrep(searchWord, searchPath, l:SearchFile, g:howm_fileencoding, addflag)
    else
      let addflag = MultiHowmDirGrep(searchWord, searchPath, l:SearchFile, g:howm_fileencoding, addflag, 'g:QFixHowm_ScheduleSearchDir')
    endif
  endif
  call MyGrep(searchWord, searchPath, l:SearchFile, g:howm_fileencoding, addflag)
  let sq = QFixGetqflist()
  call extend(sq, holiday_sq)
  let s:UseTitleFilter = 1
  call QFixHowmTitleFilter(sq)
  let sq = s:QFixHowmSortReminder(sq, a:mode)
  " for d in holiday_sq
  "   call filter(sq, "v:val['text'] == d['text']")
  " endfor
  if empty(sq)
    redraw | echo 'QFixHowm : Not found!'
  else
    exec 'let s:LT_' . a:mode . ' = localtime()'
    exec 'let s:sq_' . a:mode . ' = sq'
    call QFixSetqflist(sq)
    let g:QFix_SearchPath = l:howm_dir
    QFixCopen
    if g:QFixHowm_SchedulePreview == 0 && g:QFix_PreviewEnable == 1
      let g:QFix_PreviewEnable = -1
    endif
  endif
  silent exec 'lchdir ' . prevPath
  return sq
endfunction

" 日付を今日までの日数に変換
function! QFixHowmDate2Int(str)
  let str = a:str
  let retval = 'time'
  "422(22)フォーマット前提の ザ・決め打ち
  let str   = substitute(str, '[^0-9]','', 'g')
  let year  = matchstr(str, '\d\{4}')
  let str   = substitute(str, '\d\{4}','', '')
  let month = matchstr(str, '\d\{2}')
  let str   = substitute(str, '\d\{2}','', '')
  let day   = matchstr(str, '\d\{2}')
  let str   = substitute(str, '\d\{2} \?','', '')
  let hour  = matchstr(str, '\d\{2}')
  let str   = substitute(str, '\d\{2}:\?','', '')
  let min   = matchstr(str, '\d\{2}')
  if hour == '' || min == ''
    let retval = 'date'
    let hour  = strftime('%H', localtime())
    let min   = strftime('%M', localtime())
  endif
  if day == '00'
    let day = s:Overday(year, month, day)
  endif

  " 1・2月 → 前年の13・14月
  if month <= 2
    let year = year - 1
    let month = month + 12
  endif
  let dy = 365 * (year - 1) " 経過年数×365日
  let c = year / 100
  let dl = (year / 4) - c + (c / 4)  " うるう年分
  let dm = (month * 979 - 1033) / 32 " 1月1日から month 月1日までの日数
  let today = dy + dl + dm + day - 1

  if retval =~ 'date'
    return today
  endif

  let today = today - g:DateStrftime
  let sec = today * 24*60*60 + g:QFixHowm_ST * (60 * 60) "JST = -9
  let sec = sec + hour * (60 * 60) + min * 60

  return sec
endfunction

" 月末日処理
function! s:Overday(year, month, day)
  let year = a:year
  let month = a:month
  if month > 12
    let year += 1
    let month = month - 12
  endif
  let day = a:day
  let monthdays = [31,28,31,30,31,30,31,31,30,31,30,31]
  if year%4 == 0 && year%100 != 0 || year%400 == 0
    let monthdays[1] = 29
  endif
  if monthdays[month-1] < day
    let day = monthdays[month-1]
  endif
  if day == 0
    let day = monthdays[month-1]
  endif
  return day
endfunction

" 休日リスト作成
function! s:HolidayVimgrep(dir, file)
  " WindowsでDOSプロンプトを出さないために vimgrepを使用
  " ファイルが一つなので、パフォーマンスには影響がない
  let dir = a:dir
  let file = a:file
  let hdir = fnamemodify(file, ':h')
  if hdir != '.'
    let dir = hdir
    let file = fnamemodify(file, ':t')
  endif
  let dir = expand(dir)
  let dir = substitute(dir, '\\', '/', 'g')
  let ext = '[@]'
  let pattern = '^'.s:sch_dateT.ext
  let prevPath = escape(getcwd(), ' ')
  exec 'lchdir ' . escape(dir, ' ')
  let saved_sq = getloclist(0)
  lexpr ""
  let cmd = 'lvimgrep /' . escape(pattern, '/') . '/j ' . file
  silent! exec cmd
  silent exec 'lchdir ' . prevPath
  let sq = getloclist(0)
  let sq = s:QFixHowmSortReminder(sq, 'holiday')
  call filter(sq, "v:val['lnum']")
  let s:HolidayList = []
  for d in sq
    let day = QFixHowmDate2Int(d['text'])
    call add(s:HolidayList, day)
  endfor
  let sq = getloclist(0)
  for d in sq
    let d['bufnr'] = ''
    let d['col'] = ''
    let d['filename'] = a:dir . '/' . file
  endfor
  call setloclist(0, saved_sq)
  return sq
endfunction

"休日のみを取りだしてリストを作成する。
function! s:MakeHolidayList(sq)
  let s:HolidayList = []
  for d in a:sq
    let day = QFixHowmDate2Int(d['text'])
    call add(s:HolidayList, day)
  endfor
  return a:sq
endfunction

" リマインダーにpriorityをセットしてソートする
function! s:QFixHowmSortReminder(sq, mode)
  let qflist = a:sq
  let today = QFixHowmDate2Int(strftime(s:hts_date))
  let tsec = localtime()
  if exists('g:QFixHowmToday')
    let today = QFixHowmDate2Int(g:QFixHowmToday)
    let tsec  = QFixHowmDate2Int(g:QFixHowmToday . ' 00:00')
  endif

  let idx = 0
  for d in qflist
    let d.text = substitute(d.text, '\s*', '','')
    let estr = matchstr(d.text, '&'.s:sch_dateT.'\.')
    let estr = substitute(estr, '^&', '','')
    let elen = strlen(estr)
    if elen > 14
      let esec = QFixHowmDate2Int(estr)
      if estr != '' && tsec > esec
        call remove(qflist, idx)
        continue
      endif
    else
      let eday = QFixHowmDate2Int(estr)
      if estr != '' && today > eday + g:QFixHowm_EndDateOffset
        call remove(qflist, idx)
        continue
      endif
    endif

    let str = matchstr(d.text, '^\['.s:sch_date)
    let str = substitute(str, '^\[', '', '')
    let searchWord = ']'.s:sch_cmd
    let cmd = matchstr(d.text, searchWord)
    let cmd = substitute(cmd, '^]', '', '')
    let opt = matchstr(cmd, '[0-9]*$')
    let str = s:CnvRepeatDate(cmd, opt, str)
    let d.text = '[' . str . strpart(d.text, 11)
    let desc  = escape(cmd[0], '~')
    let dow = ''
    if g:QFixHowm_ShowScheduleDayOfWeek
      let dow = ' '.s:DoW[QFixHowmDate2Int(str)%7]
    endif
    if cmd =~ '@' && opt > 1 && opt >= 2
      let dow = opt . dow
    endif
    let d.text = substitute(d.text, ']'.escape(cmd, '~*'),  ']'. desc . dow, '')
    let cmd = cmd[0]
    if opt == ''
      if cmd =~ '^-'
        let opt = g:QFixHowm_ReminderDefault_Reminder
      elseif cmd =~ '^+'
        let opt = g:QFixHowm_ReminderDefault_Todo
      elseif cmd =~ '^\!'
        let opt = g:QFixHowm_ReminderDefault_Deadline
      elseif cmd =~ '^\~'
        let opt = g:QFixHowm_ReminderDefault_UD
      elseif cmd =~ '^@'
        let opt = g:QFixHowm_ReminderDefault_Schedule
        let opt = -1
      elseif cmd =~ '^\.'
        let opt = 0
      endif
    endif
    let priority = QFixHowmDate2Int(str)
    let priority = s:QFixHowmGetPriority(priority, cmd, opt, today)
    let d['priority'] = priority
    let d['typepriority'] = g:QFixHowm_ReminderPriority[cmd]
    let showSchedule = g:QFixHowm_ShowSchedule
    if a:mode == 'todo'
      let showSchedule = g:QFixHowm_ShowScheduleTodo
    elseif a:mode == 'menu'
      let showSchedule = g:QFixHowm_ShowScheduleMenu
    endif
    let showSchedule = showSchedule - 1
    if showSchedule > -1
      let ext = '[@]'
      let searchWord = s:sch_dateT.ext
      let dowpat = searchWord . '\s*'.s:sch_dow.'\? '
      if d.text =~ searchWord
        if d.priority > today+showSchedule || d.priority < 0
          call remove(qflist, idx)
          continue
        endif
      endif
    endif
    if exists('g:QFixHowmToday')
      let d.text = d.text . "\t\t(" . priority . ")"
    else
      if priority < g:QFixHowm_RemovePriority
        call remove(qflist, idx)
        continue
      endif
      if g:QFixHowm_RemovePriorityDays && priority < today - g:QFixHowm_RemovePriorityDays
        call remove(qflist, idx)
        continue
      endif
    endif
    if cmd =~ '^@' && g:QFixHowm_ReminderSortMode
      let priority = today - (priority - today)
      let qflist[idx]['priority'] = priority
    endif
    let d.text = substitute(d.text, '\s*&'.s:sch_dateT.'\.\s*', ' ', '')
    let d.text = substitute(d.text, '\s*$', '', '')
    let idx = idx + 1
  endfor

  let todayfname = expand(g:howm_dir).'/'.g:QFixHowm_TodayFname
  let todaypriority = g:QFixHowm_ReminderPriority[g:QFixHowm_TodayLineType]
  let sepdat = {"priority":today, "text": strftime('['.s:hts_dateTime.']$'), "typepriority":todaypriority, "filename":todayfname, "lnum":0, "bufnr":-1}
  call add(qflist, sepdat)
  let qflist = sort(qflist, "s:QFixComparePriority")

  let idx = 0
  let QFixHowmReminderTodayLineBeg = 0
  let QFixHowmReminderTodayLine = 0
  let prevtext = ''
  let prevpriority = -1

  let tline = 0
  for d in qflist
    if d.priority == prevpriority && d.text == prevtext && g:QFixHowm_RemoveSameSchedule == 1
      call remove(qflist, tline)
      continue
    endif
    let tline += 1
    let prevtext = d.text
    let prevpriority = d.priority
    "FIXME:
    if g:QFixHowm_ReminderSortMode
      if d.priority > today
        let QFixHowmReminderTodayLineBeg = QFixHowmReminderTodayLineBeg + 1
      endif
      if d.priority < today
        continue
      endif
    else
      if d.priority < today
        let QFixHowmReminderTodayLineBeg = QFixHowmReminderTodayLineBeg + 1
      endif
      if d.priority > today
        continue
      endif
    endif
    let QFixHowmReminderTodayLine += 1
  endfor

  let ttime = (today - g:DateStrftime) * 24 * 60 * 60 + g:QFixHowm_ST * (60 * 60) "JST = -9
  let str = strftime('['.s:hts_date.']')
  let dow = ' '
  if g:QFixHowm_ShowScheduleDayOfWeek
    let dow = ' '.s:DoW[QFixHowmDate2Int(str)%7] . ' '
  endif
  if g:QFixHowm_ShowTodayLine >= 2
    let str = strftime('['.s:hts_date.']')
  endif
  let str = strftime('['.s:hts_dateTime.']')
  let file = g:howm_dir . '/' . g:QFixHowm_ShowTodayLineStr
  let lnum = '0'
  let text = str . dow . '||'.g:QFixHowm_ShowTodayLineStr
  let file = todayfname
  let text = g:QFixHowm_ShowTodayLineStr . ' ' . str . dow . g:QFixHowm_ShowTodayLineStr
  let sep = {"filename": file, "lnum": lnum, "text": text, "bufnr":0}
  if g:QFixHowm_ShowTodayLine > 0
    call insert(qflist, sep, QFixHowmReminderTodayLine)
  endif
  let QFixHowmReminderTodayLine += 1
  let str = strftime('['.s:hts_date.']')
  let text = g:QFixHowm_ShowTodayLineStr
  let sep = {"filename": file, "lnum": lnum, "text": text, "bufnr":0}
  if g:QFixHowm_ShowTodayLine > 0
    call insert(qflist, sep, QFixHowmReminderTodayLineBeg)
  endif
  let text = g:QFixHowm_ShowTodayLineStr . strftime(' '.s:hts_time .' ') .g:QFixHowm_ShowTodayLineStr
  let hastime = 0
  for idx in range(len(qflist))
    if idx <= QFixHowmReminderTodayLineBeg
      continue
    endif
    if idx >= QFixHowmReminderTodayLine
      break
    endif
    let hastime += (match(qflist[idx].text, '^'.s:sch_dateTime) > -1)
  endfor
  let removebeg = 0
  for idx in range(len(qflist))
    if qflist[idx].bufnr == -1
      if g:QFixHowm_ShowTodayLine >= 2 && hastime > 1 && idx+1 != QFixHowmReminderTodayLine
        let qflist[idx].bufnr = 0
        let qflist[idx].text = text
        if idx-1 == QFixHowmReminderTodayLineBeg
          let removebeg = 1
        endif
      else
        call remove(qflist, idx)
        let QFixHowmReminderTodayLine -= 1
        break
      endif
    endif
  endfor
  if QFixHowmReminderTodayLineBeg+1 == QFixHowmReminderTodayLine || QFixHowmReminderTodayLineBeg == 0 || removebeg || g:QFixHowm_ShowTodayLine < 3
    if len(qflist) > QFixHowmReminderTodayLineBeg
      call remove(qflist, QFixHowmReminderTodayLineBeg)
    endif
  endif

  if !exists('g:QFixHowm_DayOfWeekDic')
    return qflist
  endif
  let pattern = '^' . s:sch_dateT . s:sch_Ext . ' '.s:sch_dow.' '
  for idx in range(len(qflist))
    let text = qflist[idx].text
    let dow = matchstr(text, pattern)
    let dow = matchstr(text, s:sch_dow)
    if dow == ''
      continue
    endif
    let to_dow = g:QFixHowm_DayOfWeekDic[dow]
    let qflist[idx].text = substitute(text, dow, to_dow, '')
  endfor

  return qflist
endfunction

" 繰り返す予定のプライオリティをセットする。
function! s:CnvRepeatDate(cmd, opt, str, ...)
  let cmd = a:cmd
  let sft = ''
  if cmd =~ '[-+]\d\+)'
    let sft = substitute(matchstr(cmd, '[-+]\d\+)'), '[^-0-9]', '', 'g')
    let cmd = substitute(cmd, '[-+]\d\+)', ')', '')
    if cmd =~ '()$'
      let cmd = substitute(cmd, '()$', '', '')
    endif
  endif

  let opt = a:opt
  if opt == ''
    let opt = 0
  endif
  let str = a:str
  let done = 0
  if a:0 > 0
    let done = 1
  endif
  if done == 0
    let rstr = s:CnvRepeatDateR(cmd, opt, str, done)
  else
    let rstr = s:CnvRepeatDateN(cmd, opt, str, done)
  endif
  if sft != ''
    let sec = QFixHowmDate2Int(rstr.' 00:00')
    let sec = sec + sft * 24 *60 *60
    let rstr = strftime(s:hts_date, sec)
  endif
  return rstr
endfunction

" 次の繰り返し予定日
function! s:CnvRepeatDateN(cmd, opt, str, done)
  let cmd = a:cmd
  let opt = a:opt
  if opt == ''
    let opt = 0
  endif
  let str = a:str
  let pstr = a:str
  let nstr = a:str
  let done = a:done

  let actday = QFixHowmDate2Int(str)
  let today  = QFixHowmDate2Int(strftime(s:hts_date))
  if exists('g:QFixHowmToday')
    let today = QFixHowmDate2Int(g:QFixHowmToday)
  endif
  let ttime = (today - g:DateStrftime) * 24 * 60 * 60 + g:QFixHowm_ST * (60 * 60) "JST = -9

  let desc  = escape(cmd[0], '~')
  let desc0 = '^'. desc . '\{1,3}'.'([1-5]\*'.s:sch_dow.')'
  let desc1 = '^'. desc . '\c([0-9]\+\([-+]\?'.s:sch_dow.'\)\?)'
  let desc2 = '^'. desc . '\{2}'
  let desc3 = '^'. desc . '\{3}'

  "曜日指定
  if cmd =~ desc0
    let ayear  = matchstr(str, '^\d\{4}')
    let amonth = strpart(substitute(str, '[^0-9]', '', 'g'), 4, 2)
    let aday   = matchstr(substitute(a:str, '[^0-9]', '', 'g'), '\d\{2}$')
    let atoday = QFixHowmDate2Int(a:str) + 1

    let stoday = QFixHowmDate2Int(strftime(s:hts_date))
    if exists('g:QFixHowmToday')
      let stoday = QFixHowmDate2Int(g:QFixHowmToday)
    endif
    if atoday > stoday
      let stoday = atoday
    endif
    if done
      let st = atoday + 1
      if st > stoday
        let stoday = st
      endif
    endif
    let sttime = (stoday - g:DateStrftime) * 24 * 60 * 60 + g:QFixHowm_ST * (60 * 60)

    let syear  = strftime('%Y', sttime)
    let smonth = strftime('%m', sttime)
    let sday   = strftime('%d', sttime)

    let dow = matchstr(cmd, s:sch_dow)
    let sft = matchstr(cmd, '[0-9]')
    if sft == ''
      let sft = 1
    endif

    let year  = syear
    let month = amonth
    if cmd =~ desc.'\{3}'
    elseif cmd =~ desc.'\{2}'
      let month = smonth
    endif

    let sday = s:CnvDoW(year, month, sft, dow)
    let sttime = (sday - g:DateStrftime) * 24 * 60 * 60 + g:QFixHowm_ST * (60 * 60)
    let year  = strftime('%Y', sttime)
    let month = strftime('%m', sttime)
    let sstr = strftime(s:hts_date, sttime)

    if sday > stoday
      let nstr = strftime(s:hts_date, sttime)
      let pstr = strftime(s:hts_date, sttime)
    else
      let pstr = strftime(s:hts_date, sttime)
      if cmd =~ desc.'\{3}'
        let year = year + 1
        let month = amonth
      elseif cmd =~ desc.'\{2}'
        let month = month + 1
      endif
      if month > 12
        let year = year + 1
        let month = 1
      endif
      let sday = s:CnvDoW(year, month, sft, dow)
      let sttime = (sday - g:DateStrftime) * 24 * 60 * 60 + g:QFixHowm_ST * (60 * 60)
      let nstr = strftime(s:hts_date, sttime)
    endif
    let pday = QFixHowmDate2Int(pstr)
    let nday = QFixHowmDate2Int(nstr)
    if done
      return nstr
    endif
    if cmd =~ '^@'
      if pday >= stoday || pday+opt > stoday
        return pstr
      else
        return nstr
      endif
    endif
    if stoday == pday
      return pstr
    else
      return nstr
    endif
  endif
  "間隔指定の繰り返し
  if cmd =~ desc1
    let step = matchstr(cmd, '\d\+')
    if step == 0
      let str = s:DayOfWeekShift(cmd, str)
      return str
    endif
    if step == 1
      if actday < today
        let tday = today
      else
        let tday = actday + step
      endif
    else
      if actday < today
        let tday = actday + step * (1 + ((today - actday - 1) / step))
      else
        let tday = actday + step
      endif
    endif
    let tday = tday - g:DateStrftime
    let ttime = tday * 24 * 60 * 60 + g:QFixHowm_ST * (60 * 60) "JST = -9
    let str = strftime(s:hts_date, ttime)
    if done
      return str
    endif
    let str = s:DayOfWeekShift(cmd, str)
    let sday = QFixHowmDate2Int(str)
    if sday < today
      let tday = tday + step
      let ttime = tday * 24 * 60 * 60 + g:QFixHowm_ST * (60 * 60) "JST = -9
      let str = strftime(s:hts_date, ttime)
    endif
    return str
  endif

  "年単位の繰り返し
  if cmd =~ desc3
    "曜日シフトで前日の予定が今日の予定の場合
    let sstr = s:DayOfWeekShift(cmd, str)
    let sday = QFixHowmDate2Int(sstr)
    if sday >= today
      if done
        "return str
      else
        return sstr
      endif
    endif
    if today >= actday && done == 0
      let year = strftime('%Y', ttime)
      let sstr = printf("%4.4d", year) . strpart(str, 4)
      let ssstr = s:DayOfWeekShift(cmd, sstr)
      let sday = QFixHowmDate2Int(ssstr)
      if sday < today
        let year = strftime('%Y', ttime) + 1
        let sstr = printf("%4.4d", year) . strpart(str, 4)
      endif
      let str = sstr
    else
      let year = matchstr(str, '^\d\{4}') + 1
      if year < strftime('%Y', ttime)
        let year = strftime('%Y', ttime)
      endif
      let sstr = printf("%4.4d", year) . strpart(str, 4)
      let ssstr = s:DayOfWeekShift(cmd, sstr)
      let sday = QFixHowmDate2Int(ssstr)
      if sday < today
        let year = strftime('%Y', ttime) + 1
        let sstr = printf("%4.4d", year) . strpart(str, 4)
      endif
      let str = sstr
    endif
    if done
      return str
    endif
    let sstr = s:DayOfWeekShift(cmd, str)
    let sday = QFixHowmDate2Int(sstr)
    return sstr
  endif

  "月単位の繰り返し
  if cmd =~ desc2
    let year  = strftime('%Y', ttime)
    let month = strftime('%m', ttime)
    let day   = strftime('%d', ttime)
    let ayear = matchstr(str, '^\d\{4}')
    let amonth = strpart(substitute(str, '[^0-9]', '', 'g'), 4, 2)
    let aday  = matchstr(substitute(a:str, '[^0-9]', '', 'g'), '\d\{2}$')
    let str = a:str

    if today > actday
      let ofs =0
      if month == amonth
        let ofs = 1
      endif
      let tstr = printf(s:sch_printfDate, year, month + ofs, s:Overday(year, month+ofs, aday))
      let pfsec = QFixHowmDate2Int(tstr.' 00:00')
      let tstr = strftime(s:hts_date, pfsec)
      let sstr = s:DayOfWeekShift(cmd, tstr)
      let tday = QFixHowmDate2Int(sstr)
      if tday >= today
        if done > 0
          return tstr
        else
          return sstr
        endif
      endif
      let tstr = printf(s:sch_printfDate, year, month, s:Overday(year, month, aday))
      let sec = QFixHowmDate2Int(tstr.' 00:00')
      let tstr = strftime(s:hts_date, sec)
      let sstr = s:DayOfWeekShift(cmd, tstr)
      let tday = QFixHowmDate2Int(sstr)
      if tday >= today
        if done > 0
          return tstr
        else
          let sstr = s:DayOfWeekShift(cmd, tstr)
          return sstr
        endif
      else
        let tstr = printf(s:sch_printfDate, year, month+1, s:Overday(year, month+1, aday))
        let sec = QFixHowmDate2Int(tstr.' 00:00')
        let tstr = strftime(s:hts_date, sec)
        return tstr
      endif
    else
      let tstr = printf(s:sch_printfDate, ayear, amonth+1, s:Overday(ayear, amonth+1, aday))
      let sec = QFixHowmDate2Int(tstr.' 00:00')
      let tstr = strftime(s:hts_date, sec)
      if done > 0
        return tstr
      else
        let sstr = s:DayOfWeekShift(cmd, tstr)
        return sstr
      endif
    endif
  endif

  "ここで曜日チェックしてずらす
  if done == 0
    return s:DayOfWeekShift(cmd, str)
  endif
  return str
endfunction

" 前の繰り返し予定日
function! s:CnvRepeatDateR(cmd, opt, str, done)
  let cmd = a:cmd
  let opt = a:opt
  if opt == ''
    let opt = 0
  endif
  let str = a:str
  let pstr = str
  let today = QFixHowmDate2Int(strftime(s:hts_date))
  if exists('g:QFixHowmToday')
    let today = QFixHowmDate2Int(g:QFixHowmToday)
  endif
  let done = a:done
  let actday = QFixHowmDate2Int(str)

  let desc  = escape(cmd[0], '~')
  let desc0 = '^'. desc . '\{1,3}'.'\c([1-5]\*'.s:sch_dow.')'
  let desc1 = '^'. desc . '\c([0-9]\+\([-+]\?'.s:sch_dow.'\)\?)'
  let desc2 = '^'. desc . '\{2}'
  let desc3 = '^'. desc . '\{3}'
  let ttime = (today - g:DateStrftime) * 24 * 60 * 60 + g:QFixHowm_ST * (60 * 60) "JST = -9
  "次のアクティベートタイム
  let nstr = s:CnvRepeatDateN(cmd, opt, str, done)
  let nactday = QFixHowmDate2Int(nstr)
  if cmd =~ desc0
    "曜日指定の繰り返し
    let stoday = QFixHowmDate2Int(nstr)
    let sttime = (stoday - g:DateStrftime) * 24 * 60 * 60 + g:QFixHowm_ST * (60 * 60)
    let syear  = strftime('%Y', sttime)
    let smonth = strftime('%m', sttime)
    let sday   = strftime('%d', sttime)
    if cmd =~ desc.'\{3}'
      let syear = syear - 1
    elseif cmd =~ desc.'\{2}'
      let smonth = smonth - 1
      if smonth < 1
        let syear = syear - 1
        let smonth = 12
      endif
    endif
    let sttime = (stoday - g:DateStrftime) * 24 * 60 * 60 + g:QFixHowm_ST * (60 * 60)

    let dow = matchstr(cmd, s:sch_dow)
    let sft = matchstr(cmd, '[0-9]')
    if sft == ''
      let sft = 1
    endif

    let sday = s:CnvDoW(syear, smonth, sft, dow)
    let sttime = (sday - g:DateStrftime) * 24 * 60 * 60 + g:QFixHowm_ST * (60 * 60)
    let pstr = strftime(s:hts_date, sttime)
  elseif cmd =~ desc1
    "間隔指定の繰り返し
    let step  = matchstr(cmd, '\d\+')
    "曜日シフトされていない間隔指定日を求める
    let ncmd = substitute(cmd, '\c[-+]'.s:sch_dow,'','')
    let nnstr = s:CnvRepeatDateN(ncmd, opt, str, done)
    let nnactday = QFixHowmDate2Int(nstr)

    let pday = nnactday - step
    let tday = pday - g:DateStrftime
    let ttime = tday * 24 * 60 * 60 + g:QFixHowm_ST * (60 * 60) "JST = -9
    let pstr = strftime(s:hts_date, ttime)
  elseif cmd =~ desc3
    "年単位の繰り返し
    let year = matchstr(nstr, '^\d\{4}') - 1
    let pstr = printf("%4.4d", year) . strpart(str, 4)
  elseif cmd =~ desc2
    "月単位の繰り返し
    let year = matchstr(nstr, '^\d\{4}')
    let month = strpart(substitute(nstr, '[^0-9]', '', 'g'), 4, 2) - 1
    if month < 1
      let month = 12
      let year = year - 1
    endif
    let day  = matchstr(a:str, '\d\{2}$')
    let day = s:Overday(year, month, day)
    let pstr = printf(s:sch_printfDate, year, month, day)
    let pfsec = QFixHowmDate2Int(pstr.' 00:00')
    let pstr = strftime(s:hts_date, pfsec)
  endif
  "ここで曜日チェックしてずらす
  let pstr = s:DayOfWeekShift(cmd, pstr)
  let pactday = QFixHowmDate2Int(pstr)
  if cmd =~ '^@'
    if pactday >= today || pactday+opt > today
      return pstr
    else
      return nstr
    endif
  endif
  if cmd =~ '^-'
    if nactday == today
      return nstr
    endif
    if pactday >= actday
      return pstr
    endif
  endif
  if cmd =~ desc0
    let stoday = QFixHowmDate2Int(a:str)
    let sttime = (stoday - g:DateStrftime) * 24 * 60 * 60 + g:QFixHowm_ST * (60 * 60)
    let syear  = strftime('%Y', sttime)
    let smonth = strftime('%m', sttime)
    let sday   = strftime('%d', sttime)

    let dow = matchstr(cmd, s:sch_dow)
    let sft = matchstr(cmd, '[0-9]')
    if sft == ''
      let sft = 1
    endif

    let sday = s:CnvDoW(syear, smonth, sft, dow)
    let sttime = (sday - g:DateStrftime) * 24 * 60 * 60 + g:QFixHowm_ST * (60 * 60)
    let pstr = strftime(s:hts_date, sttime)
    return pstr
  endif
  let str = s:DayOfWeekShift(cmd, str)
  return str
endfunction

"指定月のsft回目のdow曜日を返す
function! s:CnvDoW(year, month, sft, dow)
  let year = a:year
  let month = a:month
  let sft = a:sft
  if sft == 0 || sft == ''
    let sft = 1
  endif
  let dow = a:dow
  let sstr = printf(s:sch_printfDate, year, month, 1)
  let pfsec = QFixHowmDate2Int(sstr.' 00:00')
  let sstr = strftime(s:hts_date, pfsec)
  let fday = QFixHowmDate2Int(sstr)
  let fdow = fday%7
  let day = fday - fday%7
  let tday = day + (sft-1) * 7 + index(s:DoW, dow)

  let day = tday - g:DateStrftime - (sft-1) * 7
  let ttime = day * 24 * 60 * 60 + g:QFixHowm_ST * (60 * 60) "JST = -9
  let month = strftime('%m', ttime)
  if month != a:month
    let tday = tday + 7
  endif
  return tday
endfunction

"曜日シフト
let s:DoW = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun', 'Hdy']
function! s:DayOfWeekShift(cmd, str)
  let cmd = a:cmd
  let str = a:str
  let actday = QFixHowmDate2Int(str)

  let dow = matchstr(cmd, '[-+*]\?'.s:sch_dow)
  let sft = matchstr(dow, '[-+*]')
  if sft == '' || sft == '*'
    return str
  endif
  let dow = substitute(dow, '[-+]', '', 'g')

  "休日シフト
  if dow == 'Hdy' && exists('s:HolidayList') && s:HolidayList != []
    while 1
      if count(s:HolidayList, actday) == 0  && '\c'.s:DoW[actday%7] !~ 'Sun'
        break
      endif
      let sec = QFixHowmDate2Int(str.' 00:00')
      let sec = sec + (sft == '-' ? -1: 1) * 24 *60 *60
      let str = strftime(s:hts_date, sec)
      let actday = QFixHowmDate2Int(str)
    endwhile
    return str
  endif

  if '\c'.s:DoW[actday%7] =~ dow && dow != ''
    let sec = QFixHowmDate2Int(str.' 00:00')
    let sec = sec + (sft == '-' ? -1: 1) * 24 *60 *60
    let str = strftime(s:hts_date, sec)
  endif
  return str
endfunction

"日付からプライオリティをセットする。
"todayを基準値とし、コマンドとオプションによってプライオリティ値が計算される。
function! s:QFixHowmGetPriority(priority, cmd, opt, today)
  let priority = a:priority
  let cmd = a:cmd
  let opt = a:opt
  let today = a:today
  let days = 1

  if cmd =~ '^-'
    "* 指定日に浮きあがり, 以後は徐々に沈む
    "* 指定日までは底に潜伏
    "  沈むのを遅くするには, 猶予日数で指定(デフォルト 1 日)
    "  継続期間は 1+猶予日数
    if today >= priority
      if (today > priority + (opt-1+g:QFixHowm_ReminderOffset) * days)
        let priority = priority + (opt-1+g:QFixHowm_ReminderOffset) * days
      else
        let priority = today
      endif
    else
      let priority = 0
    endif
  elseif cmd =~ '^+'
    "* 指定日から, 徐々に浮きあがってくる
    "* 指定日までは底に潜伏
    "  浮きあがる速さは, 猶予日数で指定(デフォルト 7 日)
    if priority  <= today
      let priority = today - opt * days + today - priority
      if priority > today
        let priority = today
      endif
    else
      let priority = 0
    endif
  elseif cmd =~ '^\!'
    "# 指定日が近づくと, 浮きあがってくる
    "# 指定日以降は, 一番上に浮きっぱなし
    "  何日前から浮きはじめるかは, 猶予日数で指定(デフォルト 7 日)
    if today + opt * days >= priority
      let priority = today - (priority - today)
    else
      let priority = 0
    endif
  elseif cmd =~ '^\~'
    "# 指定日から, 浮き沈みをくりかえす
    "# 指定日までは底に潜伏
    let cycle = opt / 2
    if priority <= today
      let term = priority - today
      let len = term % cycle
      if (term / opt) % 2
        let priority = today - len
      else
        let priority = today - cycle + len
      endif
    else
      let priority = 0
    endif
  elseif cmd =~ '^@'
    "todo一覧ではなく, 予定表に表示
    let postshow = g:QFixHowm_ReminderDefault_Schedule
    if opt == 0
      let postshow = opt
    endif
    if opt <= 1
      let opt = 0
    endif
    if today > priority + opt + postshow
      let priority = -1
    endif
    if opt > 1
      if today > priority && today < priority + opt
        let priority = today
      endif
    endif
  elseif cmd =~ '^\.'
    "実行済で常に底
    let priority = -1
  endif
  return priority
endfunction

"priorityソート関数
function! s:QFixComparePriority(v1, v2)
  if a:v1.priority != a:v2.priority
    return (a:v1.priority <= a:v2.priority?1:-1)
  endif
  if a:v1.typepriority != a:v2.typepriority
    return (a:v1.typepriority >= a:v2.typepriority?1:-1)
  endif
  if a:v1.text != a:v2.text
    if g:QFixHowm_ReminderSortMode == 0
      return (a:v1.text < a:v2.text?1:-1)
    else
      let v1text = substitute(a:v1.text, '^\(\['.s:sch_date.'\) ', '\1}', '')
      let v2text = substitute(a:v2.text, '^\(\['.s:sch_date.'\) ', '\1}', '')
      return (v1text >= v2text?1:-1)
      return (a:v1.text >= a:v2.text?1:-1)
    endif
  endif
  return 1
endfunction

"繰り返し予定展開
function! QFixHowmGenerateRepeatDate()
  let save_cursor = getpos('.')
  let loop = count
  if loop == 0
    let loop = 1
  endif
  let ptext = matchstr(getline('.'), '^\s*')
  let searchWord = '^\s*'.s:sch_dateCmd
  let text = matchstr(getline('.'), searchWord)
  if text == ""
    return
  endif
  let tstr = matchstr(text, '^\s*\['.s:sch_date)
  let tstr = substitute(tstr, '^\s*\[', '', '')
  let searchWord = ']'.s:sch_cmd
  let cmd = matchstr(getline('.'), searchWord)
  let cmd = substitute(cmd, '^]', '', '')

  "単発予定は一日繰り返しにする
  let pattern = '^\('.s:sch_Ext.'\)\(\d\|$\)'
  if cmd =~ pattern
    let cmd = substitute(cmd, pattern, '\1(1)\2', '')
  endif
  let pattern = '^\('.s:sch_Ext.'(\)\([-+]'.s:sch_dow.')\)'
  if cmd =~ pattern
    let cmd = substitute(cmd, pattern, '\11\2', '')
  endif

  let rep = ''
  if cmd =~ '[-@!+~.]\{2}'
    let rep = substitute(tstr, '^\(\d\{4}.\d\{2}.\)\(\d\{2}\).*', '\2', '')
  endif
  let opt = matchstr(cmd, '[0-9]*$')
  if rep
    let tstr = substitute(tstr, '^\(\d\{4}.\d\{2}.\)\d\{2}', '\1'.rep, '')
  endif
  let cpattern = s:CnvRepeatDate(cmd, opt, tstr, -1)
  let str = getline('.')
  let pstr = ''
  for n in range(loop)
    if rep == '00'
      let tstr = substitute(tstr, '^\(\d\{4}.\d\{2}.\)\d\{2}', '\1'.rep, '')
    endif
    let cpattern = s:CnvRepeatDate(cmd, opt, tstr, -1)
    let str = substitute(str, '^\s*\['.s:sch_date, '['.cpattern, '')
    let tstr = matchstr(str, '^\s*\['.s:sch_date)
    let tstr = substitute(tstr, '^\s*\[', '', '')
    let ostr = str
    "単発予定に変換
    let dstr = matchstr(ostr, s:sch_date)
    let dstr = s:DayOfWeekShift(cmd, dstr)
    let ostr = substitute(ostr, s:sch_date, dstr, '')
    let ostr = substitute(ostr, '\(]\)\('.s:sch_Ext.'\)\{1,3}', '\1\2', '')
    let ostr = substitute(ostr, '\(]'.s:sch_Ext.'\)'.'([0-9]*[-+*]\?'.s:sch_dow.'\?\([-+]\d\+\)\?)', '\1', '')
    let pstr = pstr . "\<NL>" . ptext .ostr
  endfor
  let pstr = substitute(pstr, "^\<NL>", '', '')
  put=pstr
  call setpos('.', save_cursor)
  return
endfunction

"タイトルと予定・TODOで指定文字列を含むものを非表示にする
let s:UseTitleFilter = 0
function! QFixHowmTitleFilter(sq)
  if s:UseTitleFilter == 0 || g:QFixHowm_TitleFilterReg == ''
    return
  endif
  let s:UseTitleFilter = 0
  call filter(a:sq, "v:val['text'] !~ g:QFixHowm_TitleFilterReg")
endfunction

"=============================================================================
"Quickfix(schedule mode)
"=============================================================================
"Quickfixウィンドウ上での曜日変換表示
if exists('g:QFixHowm_JpDayOfWeek') && g:QFixHowm_JpDayOfWeek
  let g:QFixHowm_DayOfWeekDic = {'Sun' : "日", 'Mon' : "月", 'Tue' : "火", 'Wed' : "水", 'Thu' : "木", 'Fri' : "金", 'Sat' : "土"}
  let g:QFixHowm_DayOfWeekReg = '\c\(Sun\|Mon\|Tue\|Wed\|Thu\|Fri\|Sat\|日\|月\|火\|水\|木\|金\|土\)'
endif
"Quickfixウィンドウ上でハイライトする曜日
if !exists('g:QFixHowm_DayOfWeekReg')
  let g:QFixHowm_DayOfWeekReg = '\c\(Sun\|Mon\|Tue\|Wed\|Thu\|Fri\|Sat\)'
endif

augroup QFixHowm
  "後で再定義される
  au!
  au BufWinEnter quickfix call <SID>QFixHowmBufWinEnter()
augroup END

function! s:QFixHowmBufWinEnter()
  "後で再定義される
  let name='howm_schedule'
  exec "runtime! syntax/" . name . ".vim syntax/" . name . "/*.vim"
  setlocal ft=qf
  call QFixHowmQFsyntax()
endfunction

"Quickfixウィンドウのシンタックス表示
function! QFixHowmQFsyntax()
  let pattern = s:sch_dateT
  let dowpat = '\s*'. g:QFixHowm_DayOfWeekReg . '\?'
  exec 'syntax match howmSchedule "'.pattern.'@\d*' .dowpat.' "'
  exec 'syntax match howmDeadline "'.pattern.'!\d*' .dowpat.' "'
  exec 'syntax match howmTodo     "'.pattern.'+\d*' .dowpat.' "'
  exec 'syntax match howmReminder "'.pattern.'-\d*' .dowpat.' "'
  exec 'syntax match howmTodoUD   "'.pattern.'\~\d*'.dowpat.' "'
  exec 'syntax match howmFinished "'.pattern.'\."'
  let pattern = ' \?'. g:QFixHowm_ReminderHolidayName
  exec 'syntax match howmHoliday "'.pattern .'"'
  if exists('g:QFixHowm_UserHolidayName')
    let pattern = ' \?'.g:QFixHowm_UserHolidayName
    exec 'syntax match howmHoliday "'.pattern .'"'
  endif
  if exists('g:QFixHowm_UserSpecialdayName')
    let pattern = ' \?'.g:QFixHowm_UserSpecialdayName
    exec 'syntax match howmSpecial "'.pattern .'"'
  endif
endfunction

"=============================================================================
"howm以外のバッファを使用するためのヘルパー関数
"=============================================================================
"howmバッファを使用する
if !exists('g:QFixHowm_HowmMode')
  let g:QFixHowm_HowmMode = 1
endif
if !exists('g:QFixHowm_UserFileExt')
  let g:QFixHowm_UserFileExt = 'mkd'
endif
if !exists('g:QFixHowm_UserFileType')
  let g:QFixHowm_UserFileType = 'markdown'
endif
" HowmMode = 0 の時 URIを QFixHowmで開く
if !exists('g:QFixHowm_UserURIopen')
  let g:QFixHowm_UserURIopen = 1
endif
" HowmMode = 0 の時 URIを QFixHowmで開く(VimWiki)
if !exists('g:QFixHowm_UserURIopen_wiki')
  let g:QFixHowm_UserURIopen_wiki = 0
endif

function! QFixHowmBufferBufEnter()
  if !IsQFixHowmFile('%')
    return
  endif
  nnoremap <silent> <buffer> <CR> :<C-u>call QFixHowmActionLock()<CR>
  let ext = fnamemodify(expand('%'), ':e')
  if !g:QFixHowm_HowmMode && (ext == g:QFixHowm_UserFileExt)
    call QFixHowmUserAutocmd(ext)
  endif
endfunction

silent! function QFixHowmUserAutocmd(ext)
  if a:ext == 'wiki'
    nnoremap <silent> <buffer> <CR> :call QFixHowmUserModeCR('VimwikiFollowLink')<CR>
  else
    nnoremap <silent> <buffer> <CR> :call QFixHowmUserModeCR()<CR>
  endif
endfunction

function! QFixHowmUserModeCR(...)
  if QFixHowmScheduleAction()
    return
  endif
  let cmd = a:0 ? a:1 : "normal! \n"
  exec cmd
endfunction

function! QFixHowmScheduleAction()
  let str = QFixHowmScheduleActionStr()
  if str == "\<ESC>"
    return 1
  endif
  if str == "\<CR>"
    return 0
  endif
  let str = substitute(str, "\<CR>", "|", "g")
  let str = substitute(str, "|$", "", "")
  silent exec str
  return 1
endfunction

function! QFixHowmScheduleActionStr()
  let save_cursor = getpos('.')
  let uriopen = g:QFixHowm_UserURIopen
  silent! exec 'let uriopen = g:QFixHowm_UserURIopen_'.g:QFixHowm_UserFileExt
  if uriopen == 1
    call setpos('.', save_cursor)
    let ret = QFixHowmOpenCursorline()
    if ret == 1
      return "\<ESC>"
    endif
  endif
  call setpos('.', save_cursor)
  let ret = QFixHowmDateActionLock()
  if ret != "\<CR>"
    return ret
  endif
  call setpos('.', save_cursor)
  let ret = QFixHowmTimeActionLock()
  if ret != "\<CR>"
    return ret
  endif
  call setpos('.', save_cursor)
  if col('.') < 36 && getline('.') =~ '^'.s:sch_dateT.s:sch_Ext
    let ret = QFixHowmSwitchActionLock(g:QFixHowm_ScheduleSwActionLock, 1)
    if ret != "\<CR>"
      return ret
    endif
  endif
  call setpos('.', save_cursor)
  if getline('.') =~ '^'.s:sch_dateT.s:sch_Ext
    call cursor('.', 1)
    let ret = QFixHowmRepeatDateActionLock()
    if ret != "\<CR>"
      return ret
    endif
  endif
  call setpos('.', save_cursor)
  return "\<CR>"
endfunction

""""""""""""""""""""""""""""""
"カーソル位置のファイルを開くアクションロック
""""""""""""""""""""""""""""""
"カーソル位置のファイルを開くアクションロック
if !exists('g:QFixHowm_OpenURIcmd')
  if !exists('g:MyOpenURI_cmd')
    let g:QFixHowm_OpenURIcmd = ""
    if has('unix')
      let g:QFixHowm_OpenURIcmd = "call system('firefox %s &')"
    else
      "Internet Explorer
      let g:QFixHowm_OpenURIcmd = '!start "C:/Program Files/Internet Explorer/iexplore.exe" %s'
      let g:QFixHowm_OpenURIcmd = '!start "rundll32.exe" url.dll,FileProtocolHandler %s'
    endif
  else
    let g:QFixHowm_OpenURIcmd = g:MyOpenURI_cmd
  endif
endif
"vimで開くファイルリンク
if !exists('g:QFixHowm_OpenVimExtReg')
  if !exists('g:MyOpenVim_ExtReg')
    let g:QFixHowm_OpenVimExtReg = '\.txt$\|\.vim$'
  else
    let g:QFixHowm_OpenVimExtReg = g:MyOpenVim_ExtReg
  endif
endif
"はてなのhttp記法のゴミを取り除く
if !exists('g:QFixHowm_removeHatenaTag')
  let g:QFixHowm_removeHatenaTag = 1
endif
command! QFixHowmOpenCursorline call QFixHowmOpenCursorline()
function! QFixHowmOpenCursorline()
  let prevcol = col('.')
  let prevline = line('.')
  let str = getline('.')
  let l:howm_dir = substitute(g:howm_dir, '\\', '/', 'g')
  let l:QFixHowm_RelPath = substitute(g:QFixHowm_RelPath, '\\', '/', 'g')

  " >>>
  let pos = match(str, g:howm_glink_pattern)
  if pos > -1 && col('.') >= pos
    let str = strpart(str, pos)
    let str = substitute(str, '^\s*\|\s*$', '', 'g')
    let str = substitute(str, '^'.g:howm_glink_pattern.'\s*', '', '')
    let path = l:QFixHowm_RelPath . (str =~ 'rel://[^/\\]' ? '/' : '')
    let str = substitute(str, 'rel://', path, 'g')
    let path = l:howm_dir . (str =~ 'howm://[^/\\]' ? '/' : '')
    let str = substitute(str, 'howm://', path, 'g')
    let imgsfx   = '\(\.jpg\|\.jpeg\|\.png\|\.bmp\|\.gif\)$'
    if str =~ imgsfx
      let str = substitute(str, '^&', '', '')
    endif
    return s:openstr(str)
  endif

  "カーソル位置の文字列を拾う[:c:/temp/test.jpg:]や[:http://example.com:(title=hoge)]形式
  let pathhead = '\([A-Za-z]:[/\\]\|\~/\)'
  let urireg = '\(\(howm\|rel\|http\|https\|file\|ftp\)://\|'.pathhead.'\)'
  let [lnum, colf] = searchpos('\[:\?&\?'.urireg, 'bc', line('.'))
  if lnum != 0 && colf != 0
    let str = strpart(getline('.'), colf-1)
    let lstr = substitute(str, '\[:\?&\?'.urireg, '', '')
    let len = matchend(lstr, ':[^\]]*]')
    if len < 0
      let str = ''
    else
      let len += matchend(str, '\[:\?&\?'.urireg)
      let str = strpart(str, 0, len)
    endif
    call cursor(prevline, prevcol)
    if str != ''
      if str =~ '^\[:\?'
        let str = substitute(str, ':\(title=\|image[:=]\)\([^\]]*\)\?]$', ':]', '')
        let str = substitute(str, ':[^:\]]*]$', '', '')
      endif
      let str = substitute(str, '^\[:\?&\?', '', '')
      let path = l:QFixHowm_RelPath . (str =~ 'rel://[^/\\]' ? '/' : '')
      let str = substitute(str, 'rel://', path, 'g')
      let path = l:howm_dir . (str =~ 'howm://[^/\\]' ? '/' : '')
      let str = substitute(str, 'howm://', path, 'g')
      return s:openstr(str)
    endif
  endif

  "カーソル位置の文字列を拾う
  let urichr  =  "[-0-9a-zA-Z;/?:@&=+$,_.!~*'()%]"
  let pathchr =  "[-0-9a-zA-Z;/?:@&=+$,_.!~*'()%{}[\\]\\\\ ]"
  let pathhead = '\([A-Za-z]:[/\\]\|\~/\)'
  let urireg = '\(\(howm\|rel\|http\|https\|file\|ftp\)://\|'.pathhead.'\)'
  let [lnum, colf] = searchpos(urireg, 'bc', line('.'))
  if colf == 0 && lnum == 0
    return "\<CR>"
  endif
  let str = strpart(getline('.'), colf-1)
  if str =~ '^https\?:\|^ftp:'
    let str = matchstr(str, urichr.'\+')
  else
    let str = matchstr(str, pathchr.'\+')
  endif
  if colf > prevcol || colf + strlen(str) <= prevcol
    return "\<CR>"
  endif
  call cursor(prevline, prevcol)

  let str = substitute(str, ':$\|\(|:title=\|:image\|:image[:=]\)'.pathchr.'*$', '', '')
  if str != ''
    let path = l:QFixHowm_RelPath . (str =~ 'rel://[^/\\]' ? '/' : '')
    let str = substitute(str, 'rel://', path, 'g')
    let path = l:howm_dir . (str =~ 'howm://[^/\\]' ? '/' : '')
    let str = substitute(str, 'howm://', path, 'g')
    return s:openstr(str)
  endif
  return "\<CR>"
endfunction

function! s:EncodeURL(str, ...)
  let to_enc = 'utf8'
  if a:0
    let to_enc = a:1
  endif
  let str = iconv(a:str, &enc, to_enc)
  let save_enc = &enc
  let &enc = to_enc
  "FIXME:本当は'[^-0-9a-zA-Z._~]'を変換？
  let str = substitute(str, '[^[:print:]]', '\=s:URLByte2hex(s:URLStr2byte(submatch(0)))', 'g')
  let str = substitute(str, ' ', '%20', 'g')
  let &enc = save_enc
  return str
endfunction

function! s:URLStr2byte(str)
  return map(range(len(a:str)), 'char2nr(a:str[v:val])')
endfunction

function! s:URLByte2hex(bytes)
  return join(map(copy(a:bytes), 'printf("%%%02X", v:val)'), '')
endfunction

function! s:openstr(str)
  let str = a:str
  let str = substitute(str, '[[:space:]]*$', '', '')
  let l:MyOpenVim_ExtReg = '\.'.g:QFixHowm_FileExt.'$'.'\|\.'.s:howmsuffix.'$'
  if g:QFixHowm_OpenVimExtReg != ''
    let l:MyOpenVim_ExtReg = l:MyOpenVim_ExtReg.'\|'.g:QFixHowm_OpenVimExtReg
  endif

  "vimか指定のプログラムで開く
  let pathhead = '\([A-Za-z]:[/\\]\|\~/\|/\)'
  if str =~ '^'.pathhead
    if str !~ l:MyOpenVim_ExtReg
      let ext = fnamemodify(str, ':e')
      if exists('g:QFixHowm_Opencmd_'.ext)
        exec 'let cmd = g:QFixHowm_Opencmd_'.ext
        let str = expand(str)
        if has('unix')
          let str = escape(str, ' ')
        endif
        let cmd = substitute(cmd, '%s', escape(str, '&\'), '')
        let cmd = escape(cmd, '%#')
        silent exec cmd
        return 1
      endif
    else
      let str = escape(str, ' ')
      exec g:QFixHowm_Edit.'edit '. escape(str, ' %#')
      return 1
    endif
    if fnamemodify(str, ':e') == ''
      let str = escape(str, ' ')
      exec g:QFixHowm_Edit.'edit '. escape(str, ' %#')
      return 1
    endif
  endif

  let urireg = '\(\(https\|http\|file\|ftp\)://\|'.pathhead.'\)'
  if str !~ '^'.urireg
    return "\<CR>"
  endif
  "あとはブラウザで開く
  let uri = str
  if uri =~ '^file://'
    let uri = substitute(uri, '^file://', '', '')
    let uri = expand(uri)
    let uri = 'file://'.uri
  endif
  if uri =~ '^'.pathhead
    let uri = expand(uri)
    let uri = 'file://'.uri
  endif
  let uri = substitute(uri, '\', '/', 'g')
  if uri == ''
    return "\<CR>"
  endif
  return s:OpenUri(uri)
endfunction

function! s:OpenUri(uri)
  let cmd = ''
  let bat = 0

  let uri = a:uri
  if uri =~ '^http[s]\?\|^ftp'
    let char = "[-A-Za-z0-9-_./~,$!*'();:@=&+]"
    let uri = substitute(uri, '\s\+.*$', '', '')
    if g:QFixHowm_removeHatenaTag
      let uri = substitute(uri, ':\(\(title\|image\)=[^\]]\+\)\?$', '', '')
    endif
  endif
  if has('win32') || has('win64')
    if &enc != 'cp932' && uri =~ '^file://' && uri =~ '[^[:print:]]'
      let bat = 1
    endif
  endif
  if g:QFixHowm_OpenURIcmd != ''
    let cmd = g:QFixHowm_OpenURIcmd
    if g:QFixHowm_OpenURIcmd =~ '\(rundll32\|iexplore\(\.exe\)\?\)' && uri =~ '^file://'
    else
      let uri = s:EncodeURL(uri, &enc)
    endif
    "Windowsで &encが cp932以外か !start cmd /c が指定されていたらバッチ化して実行
    if bat || cmd =~ '^!start\s*cmd\(\.exe\)\?\s*/c'
      let cmd = substitute(cmd, '^[^"]\+', '', '')
      let uri = substitute(uri, '&', '"\&"', 'g')
      let uri = substitute(uri, '%', '%%', 'g')
      let cmd = substitute(cmd, '%s', escape(uri, '&'), '')
      let cmd = iconv(cmd, &enc, 'cp932')
      let s:uricmdfile = fnamemodify(s:howmtempfile, ':p:h') . '/uricmd.bat'
      call writefile([cmd], s:uricmdfile)
      let cmd = '!start "'.s:uricmdfile.'"'
      silent exec cmd
      return 1
    endif
    let cmd = substitute(cmd, '%s', escape(uri, '&'), '')
    let cmd = escape(cmd, '%#')
    silent exec cmd
    return 1
  endif
  return 0
endfunction

""""""""""""""""""""""""""""""
" スイッチアクションロック
function! QFixHowmSwitchActionLock(list, ...)
  let prevline = line('.')
  let prevcol = 0
  if a:0 > 0
    let prevcol = col('.')
  endif
  let max = len(a:list)
  let didx = 0
  for d in a:list
    let pattern = d
    let didx = didx + 1
    if didx >= max
      let didx = 0
    endif
    let cpattern = a:list[didx]
    let nr = 1
    while 1
      if byteidx(pattern, nr) == -1
        break
      endif
      let nr = nr + 1
    endwhile
    let nr = nr - 1
    let pattern = escape(pattern, '*[.~')
    let start = col('.') - strlen(matchstr(pattern, '^.\{'.nr.'}')) + strlen(matchstr(pattern, '^.\{1}')) - 1
    if start < 0
      let start = 0
    endif
    let end = col('.') + strlen(matchstr(pattern, '.\{'.nr.'}$'))-1
    let str = strpart(getline('.'), start, end-start)
    if str !~ pattern
      continue
      return "\<CR>"
    endif
    let start = start + match(str, pattern) + 1
    if a:0 == 0
      let prevcol = start
    endif
    if str =~ '{_}'
      let cpattern = strftime('['.s:hts_dateTime.'].')
    endif
    return ":call cursor(line('.'),".start.")\<CR>:exec 'normal! c".nr."l".cpattern."'\<CR>:call cursor(".prevline.",".prevcol.")\<CR>"
  endfor
  return "\<CR>"
endfunction

"曜日のアクションロック
if !exists('g:QFixHowm_ScheduleSwActionLock')
  let g:QFixHowm_ScheduleSwActionLock= ['Sun)', 'Mon)', 'Tue)', 'Wed)', 'Thu)', 'Fri)', 'Sat)', 'Hdy)']
endif

" 時間のアクションロック
function! QFixHowmTimeActionLock()
  if col('.') > matchend(getline('.'), '^\s*'.s:sch_dateTime) || getline('.') !~ '^\s*'.s:sch_dateTime
    return "\<CR>"
  endif
  let prevline = line('.')
  let prevcol = col('.')

  let pattern = ' '.s:sch_time.']'
  let len = 7 "sizeof pattern
  let start = col('.') - len
  if start < 0
    let start = 0
  endif
  let end = col('.') + len
  let str = strpart(getline('.'), start, end-start)
  if str !~ pattern
    return "\<CR>"
  endif
  let start = start + match(str, pattern) + 1
  if col('.') < start
    return "\<CR>"
  endif

  let pattern = s:sch_time
  let len = 5 "sizeof pattern
  let start = col('.') - len
  if start < 0
    let start = 0
  endif
  let end = col('.') + len
  let str = strpart(getline('.'), start, end-start)
  if str !~ pattern
    return "\<CR>"
  endif
  let start = start + match(str, pattern) + 1
  if col('.') < start
    return "\<CR>"
  endif

  let dpattern = matchstr(str, pattern)
  let pattern = input(' 01-059, 60-999, 01000-02359, 2400- ([+-]min), hhmm/0-59 (set), . (current) : ', '')
  if pattern == ''
    return "\<ESC>"
  elseif pattern == '.'
    let cpattern = strftime(s:hts_time)
  elseif pattern =~ '^\d\{2}:\d\{2}'
    let sec = QFixHowmDate2Int(strftime(s:hts_date).' '.pattern)
    let cpattern = strftime(s:hts_time, sec)
  elseif pattern =~ '[-+]\?\d\+'
    let num = substitute(pattern, '^[0+]*', '', '')
    if pattern =~ '^\d\{4}$' && num < 2400
      let sec = QFixHowmDate2Int(strftime(s:hts_date).' '.pattern)
      let sec = sec
      let cpattern = strftime(s:hts_time, sec)
    elseif pattern =~ '^\d$' || (pattern =~ '^\d\{2}$' && num < 60 && num == pattern)
      let cpattern = substitute(dpattern, '\d\d$', '', '') . printf('%2.2d', num)
    else
      let sec = QFixHowmDate2Int(strftime(s:hts_date).' '.dpattern)
      let sec = sec + num*60
      let cpattern = strftime(s:hts_time, sec)
    endif
  else
    return ":call cursor(".prevline.",".prevcol.")\<CR>"
  endif
  return ":call cursor(line('.'),".start.")\<CR>:exec 'normal! c".len."l".cpattern."'\<CR>:call cursor(".prevline.",".prevcol.")\<CR>"
endfunction

" 日付のアクションロック
function! QFixHowmDateActionLock()
  if col('.') > matchend(getline('.'), '^\s*'.s:sch_dateT) || getline('.') !~ '^\s*'.s:sch_dateT
    return "\<CR>"
  endif
  let prevline = line('.')
  let prevcol = col('.')
  let pattern = s:sch_date
  let len = strlen(strftime(s:hts_date))
  let start = col('.') - len
  if start < 0
    let start = 0
  endif
  let end = col('.') + len
  let str = strpart(getline('.'), start, end-start)
  if str !~ pattern
    return "\<CR>"
  endif
  let start = start + match(str, pattern) + 1
  if col('.') < start
    return "\<CR>"
  endif
  let dpattern = matchstr(str, pattern)
  let pattern = input(' 01-031,32-999 ([+-]day), yymmdd/mmdd/1-31 (set), . (today) : ', '')
  if pattern == ''
    let pattern = dpattern
    if g:QFixHowm_DateActionLockDefault == 0
      return "\<ESC>"
    endif
    if g:QFixHowm_DateActionLockDefault == 1
      "TODO:vimgrepだったら/をエスケープ
      let patten = escape(pattern, '/')
      let s:QFixHowmALSPat = pattern
      call QFixHowmActionLockSearch(1, 'QFixHowm Grep : ')
      return "\<ESC>"
    endif
    if g:QFixHowm_DateActionLockDefault == 2
      call QFixHowmListReminder('schedule')
      return "\<ESC>"
    endif
    if g:QFixHowm_DateActionLockDefault == 3
      call QFixHowmListReminder('todo')
      return "\<ESC>"
    endif
    return "\<CR>"
  elseif pattern == '.'
    let cpattern = strftime(s:hts_date)
  elseif pattern =~ '^[-+]\d\+$'
    let pattern = substitute(pattern, '^[+0]*', '', '')
    let sec = pattern * 24*60*60
    let sec = sec + QFixHowmDate2Int(dpattern.' 00:00')
    let cpattern = strftime(s:hts_date, sec)
  elseif pattern =~ '^\d\{8}$' || pattern =~ '^'.s:sch_date.'$'
    let pattern = substitute(pattern, '[^0-9]', '', 'g')
    let sec = QFixHowmDate2Int(pattern.' 00:00')
    let cpattern = strftime(s:hts_date, sec)
    let year = strpart(pattern, 0, 4)
    if cpattern !~ s:sch_date || year < g:YearStrftime
      let month = strpart(pattern, 4, 2)
      let day = strpart(pattern, 6, 2)
      let cpattern = substitute(g:QFixHowm_DatePattern, '%Y', year, '')
      let cpattern = substitute(cpattern, '%m', month, '')
      let cpattern = substitute(cpattern, '%d', day, '')
    endif
  elseif pattern =~ '^\d\{6}$'
    let sec = QFixHowmDate2Int('20'.pattern.' 00:00')
    let cpattern = strftime(s:hts_date, sec)
    if cpattern !~ s:sch_date
      let year  = '20' . strpart(pattern, 0, 2)
      let month = strpart(pattern, 2, 2)
      let day   = strpart(pattern, 4, 2)
      let cpattern = substitute(g:QFixHowm_DatePattern, '%Y', year, '')
      let cpattern = substitute(cpattern, '%m', month, '')
      let cpattern = substitute(cpattern, '%d', day, '')
    endif
  elseif pattern =~ '^\d\{4}$'
    let head = matchstr(dpattern, '\d\{4}')
    let sec = QFixHowmDate2Int(head . pattern.' 00:00')
    let cpattern = strftime(s:hts_date, sec)
  elseif pattern =~ '^\d\{1,3}$'
    if pattern[0] != '0' && pattern < 32
      let head = substitute(dpattern, '\d\{2}$', '', '')
      let cpattern = head . printf('%2.2d', pattern)
      let sec = QFixHowmDate2Int(cpattern .' 00:00')
    else
      if pattern + 0 == 0
        let cpattern = strftime(s:hts_date)
        let sec = QFixHowmDate2Int(cpattern.' 00:00')
        let sec = QFixHowmDate2Int(cpattern.' 00:00')
      else
        let pattern = substitute(pattern, '^[+0]*', '', '')
        let sec = pattern * 24*60*60
        let sec = sec + QFixHowmDate2Int(dpattern.' 00:00')
      endif
    endif
    let cpattern = strftime(s:hts_date, sec)
  else
    return ":call cursor(".prevline.",".prevcol.")\<CR>"
  endif
  return ":call cursor(line('.'),".start.")\<CR>:exec 'normal! c".len."l".cpattern."'\<CR>:call cursor(".prevline.",".prevcol.")\<CR>"
endfunction

" 繰り返し予定のアクションロック
function! QFixHowmRepeatDateActionLock()
  let prevline = line('.')
  let prevcol = col('.')
  let start = 2
  let cpattern = strftime(s:hts_date)
  let len = strlen(cpattern)
  let searchWord = '^\s*'.s:sch_dateCmd
  let text = matchstr(getline('.'), searchWord)
  if text == "" || col('.') > strlen(text)
    return "\<CR>"
  endif
  let str = matchstr(text, '^\s*\['.s:sch_date)
  let str = substitute(str, '^\s*\[', '', '')
  let searchWord = ']'.s:sch_cmd
  let cmd = matchstr(getline('.'), searchWord)
  let cmd = substitute(cmd, '^]', '', '')
  if cmd =~ '^\.'
    return "\<CR>"
  endif
  let opt = matchstr(cmd, '[0-9]*$')
  let clen = matchstr(cmd, '^'.s:sch_Ext.'\+')
  let ccmd = matchstr(cmd, s:sch_Ext.'(')
  if strlen(ccmd) == 0 && strlen(clen) == 1
    let searchWord = '^\s*'.s:sch_dateT
    let len = matchend(getline('.'), searchWord) + 1
    return ":call cursor(line('.'),".len.")\<CR>:exec 'normal! r.'\<CR>:call cursor(".prevline.",".prevcol.")\<CR>"
  endif
  let cpattern = s:CnvRepeatDate(cmd, opt, str, -1)
  if match(str, '\d\{4}.\d\{2}.00') == 0
    let cpattern = substitute(cpattern, '\(\d\{4}.\d\{2}.\)\d\{2}', '\100', '')
  endif
  let start = 2 + match(getline('.'), s:sch_dateT)
  return ":call cursor(line('.'),".start.")\<CR>:exec 'normal! c".len."l".cpattern."'\<CR>:call cursor(".prevline.",".prevcol.")\<CR>"
endfunction

""""""""""""""""""""""""""""""
" QFixHowmファイル判定
""""""""""""""""""""""""""""""
"howmファイルの拡張子
if !exists('g:loaded_MyHowmChEnv')
  let g:QFixHowm_FileExt = fnamemodify(g:howm_filename,':e')
endif
"howmファイルタイプ
if !exists('g:QFixHowm_FileType')
  let g:QFixHowm_FileType = 'howm_memo'
endif
"ファイル読込の際に、ファイルエンコーディングを強制する
if !exists('g:QFixHowm_ForceEncoding')
  let g:QFixHowm_ForceEncoding = 1
endif
"howm_dirの最大数
if !exists('g:QFixHowm_howm_dir_Max')
  let g:QFixHowm_howm_dir_Max = 8
endif

function! IsQFixHowmFile(file, ...)
  let file = a:file
  if file == '%' && &filetype =~ g:QFixHowm_FileType
    return 1
  endif
  if file == '%'
    let file = expand(file)
  endif
  let file = fnamemodify(file, ':p')
  let file = substitute(file, '\\', '/', 'g')
  let ext = fnamemodify(file, ':e')
  let usermode = !g:QFixHowm_HowmMode && (ext == g:QFixHowm_UserFileExt)

  if ext == s:howmsuffix
    return 1
  elseif ext != g:QFixHowm_FileExt && !usermode
    return 0
    if a:0 == 0 || a:1 == ''
      return 0
    elseif a:1 == '*'
      "do nothing
    elseif file !~ a:1
      return 0
    endif
  endif

  let head = expand(g:howm_dir)
  let head = substitute(head, '\\', '/', 'g')
  if file =~ '^'.head
    return 2
  endif

  "Multi howm_dir
  let basename    = 'g:howm_dir'
  for i in range(2, g:QFixHowm_howm_dir_Max)
    if !exists(basename.i)
      continue
    endif
    exec 'let hdir = '.basename.i
    let hdir = expand(hdir)
    let hdir = substitute(hdir, '\\', '/', 'g')
    if isdirectory(hdir) == 0
      continue
    endif
    if file =~ '^'.hdir
      return 2
    endif
  endfor
  return 0
endfunction

function! QFixPreviewReadOpt(file)
  let file = a:file
  let opt = ''
  if g:QFixHowm_ForceEncoding && IsQFixHowmFile(file)
    let opt = ' ++enc='.g:howm_fileencoding .' ++ff='.g:howm_fileformat
  endif
  return opt
endfunction

function! QFixHowmFileType(file)
  if IsQFixHowmFile(a:file) == 0
    return
  endif
  let file = a:file == '%' ? expand('%:p') : a:file
  if g:QFixHowm_HowmMode == 0 && fnamemodify(file, ':e') == g:QFixHowm_UserFileExt
    return
  endif
  let file = fnamemodify(file, ':p')
  if exists('g:QFixHowm_PairLinkDir') && file =~ '[/\\]'.g:QFixHowm_PairLinkDir .'[/\\]'
    let file = fnamemodify(file, ':t')
    exec 'doau BufRead '.fnamemodify(file, ':r')
    let type = &filetype
    call s:SetbuflocalSettings()
    exec 'setlocal filetype='.type.'.'.g:QFixHowm_FileType
  else
    exec 'setlocal filetype='.g:QFixHowm_FileType
  endif
endfunction

function! s:SetbuflocalSettings()
  " 後で再定義される
endfunction

function! QFixFtype(file)
  let ext = fnamemodify(a:file, ':e')
  if ext == s:howmsuffix || ext == g:QFixHowm_FileExt
    call QFixHowmFileType(a:file)
    return
  endif
endfunction

let loaded_HowmSchedule = 1

" 予定・TODOのみ使用したい場合
if exists('g:HowmSchedule_only') && g:HowmSchedule_only
  finish
endif

"=============================================================================
"    Description: howmバッファ関数
"  Last Modified: 0000-00-00 00:00
"        Version: 0.00
"=============================================================================
if exists('disable_QFixWin') && disable_QFixWin == 1
  finish
endif
if exists('disable_MyHowm') && disable_MyHowm
  finish
endif
if exists("loaded_MyHowm") && !exists('fudist')
  finish
endif
if v:version < 700 || &cp || !has('quickfix')
  finish
endif
let loaded_MyHowm = 1

let s:debug = 0
if exists('g:fudist') && g:fudist
  let s:debug = 1
endif
if !exists('g:qfixtempname')
  let g:qfixtempname = tempname()
endif
let s:howmtempfile = g:qfixtempname

"=============================================================================
" キーマップ/メニュー登録
"=============================================================================
"howmキーマップ
"最近"更新"したファイルの検索
if !exists('g:QFixHowm_Key_SearchRecent')
  let g:QFixHowm_Key_SearchRecent    = 'l'
endif
"最近"作成" したファイルの検索
if !exists('g:QFixHowm_Key_SearchRecentAlt')
  let g:QFixHowm_Key_SearchRecentAlt = 'L'
endif
"最近"更新/閲覧"したファイルの検索
if !exists('g:QFixHowm_Key_SearchMRU')
  let g:QFixHowm_Key_SearchMRU       = 'm'
endif

if g:QFixHowm_Default_Key > 0
  let s:QFixHowm_Key = g:QFixHowm_Key . g:QFixHowm_KeyB
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.',  :<C-u>call QFixHowmOpenMenu("cache")<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'r, :<C-u>call QFixHowmOpenMenu()<CR>'

  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.g:QFixHowm_Key_SearchRecent.' :QFixHowmListRecent<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.g:QFixHowm_Key_SearchRecentAlt.' :QFixHowmListRecentC<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'r'.g:QFixHowm_Key_SearchMRU.' :<C-u>call QFixHowmMru(1)<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.g:QFixHowm_Key_SearchMRU.' :<C-u>call QFixHowmMru(0)<CR>'

  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'c :<C-u>call QFixHowmCreateNewFile()<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'C :<C-u>call QFixHowmCreateNewFile("")<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'u :QFixHowmOpenQuickMemo<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'U :<C-u>let g:QFixHowm_QMF = g:QFixHowm_QuickMemoFile<CR>:QFixHowmOpenQuickMemo<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'<Space> :<C-u>call QFixHowmOpenDiary()<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'s :<C-u>call QFixHowmSearchInput("QFixHowm FGrep : ", 0)<CR>'
  exec 'silent! vnoremap <unique> <silent> '.s:QFixHowm_Key.'s :<C-u>call QFixHowmSearchInput("QFixHowm FGrep : ", 0, "visual")<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'g :<C-u>call QFixHowmSearchInput("QFixHowm Grep : ", 1)<CR>'
  exec 'silent! vnoremap <unique> <silent> '.s:QFixHowm_Key.'g :<C-u>call QFixHowmSearchInput("QFixHowm Grep : ", 1, "visual")<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'\g :<C-u>call QFixHowmVSearchInput("QFixHowm VGrep : ", 1)<CR>'
  exec 'silent! vnoremap <unique> <silent> '.s:QFixHowm_Key.'\g :<C-u>call QFixHowmVSearchInput("QFixHowm VGrep : ", 1, "visual")<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'a :<C-u>call QFixHowmListAllTitle(g:QFixHowm_Title, 0)<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'ra :<C-u>call QFixHowmListAllTitleAlt("reload")<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'rn :<C-u>call QFixHowmRename_()<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'rN :<C-u>QFixHowmRenameAll<CR>'

  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'rr :QFixHowmRandomWalk<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'rR :call QFixHowmRebuildRandomWalkFile(g:QFixHowm_RandomWalkFile)<CR>:QFixHowmRandomWalk<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'A :<C-u>call QFixHowmListDiary()<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'rA :<C-u>let g:QFixHowm_FileListMax = 0\|QFixHowmFileList<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'rk :<C-u>call QFixHowmRebuildKeyword()<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'i  :<C-u>call ToggleQFixSubWindow()<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'I  :<C-u>call QFixHowmPairFile()<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'j  :<C-u>call QFixHowmPairFile()<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'J  :<C-u>call QFixHowmPairFile()<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'Y  :QFixHowmAlarmReadFile!<CR>'
  exec 'silent! nnoremap <unique> <silent> '.s:QFixHowm_Key.'H  :call QFixHowmHelp()<CR>'
  exec "silent! nnoremap <unique> <silent> ".s:QFixHowm_Key."z :call CnvWildcardChapter()<CR>"
  exec "silent! vnoremap <unique> <silent> ".s:QFixHowm_Key."z :call CnvWildcardChapter('visual')<CR>"
  exec "silent! nnoremap <unique> <silent> ".s:QFixHowm_Key."hf :<C-u>call QFixHowmFileLink()<CR>"
  exec "silent! nnoremap <unique> <silent> ".s:QFixHowm_Key."o :call QFixHowmOutline()<CR>"

  exec 'silent! nmap     <silent> <expr> '.s:QFixHowm_Key.'e !IsQFixHowmFile("%") ? ":QFGrep!<CR>"  : "'.s:QFixHowm_Key.'g"'
  exec 'silent! nmap     <silent> <expr> '.s:QFixHowm_Key.'f !IsQFixHowmFile("%") ? ":QFFGrep!<CR>" : "'.s:QFixHowm_Key.'s"'
  exec 'silent! nmap     <silent> <expr> '.s:QFixHowm_Key.'v !IsQFixHowmFile("%") ? ":QFVGrep!<CR>" : "'.s:QFixHowm_Key.'\\g"'
  exec 'silent! vmap     <silent> <expr> '.s:QFixHowm_Key.'e !IsQFixHowmFile("%") ? ":call Grep(\"\", -1, \"Grep\", 0)<CR>"  : "'.s:QFixHowm_Key.'g"'
  exec 'silent! vmap     <silent> <expr> '.s:QFixHowm_Key.'f !IsQFixHowmFile("%") ? ":call FGrep(\"\", -1, 0)<CR>" : "'.s:QFixHowm_Key.'s"'
  exec 'silent! vmap     <silent> <expr> '.s:QFixHowm_Key.'v !IsQFixHowmFile("%") ? ":call VGrep(\"\", -1, 0)<CR>" : "'.s:QFixHowm_Key.'\\g"'
endif

if QFixHowm_MenuBar
  let s:menu = '&Tools.QFixHowm(&H)'
  if QFixHowm_MenuBar == 2
    let s:menu = 'Howm(&O)'
  elseif QFixHowm_MenuBar == 3 || MyGrep_MenuBar == 3
    let s:menu = 'QFixApp(&Q).QFixHowm(&H)'
  endif
  let s:QFixHowm_Key = escape(g:QFixHowm_Key . g:QFixHowm_KeyB, '\\')
  exec 'amenu <silent> 41.332 '.s:menu.'.CreateNew(&C)<Tab>'.s:QFixHowm_Key.'c  :<C-u>call QFixHowmCreateNewFile()<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.CreateNew(Name)(&N)<Tab>'.s:QFixHowm_Key.'C  :<C-u>call QFixHowmCreateNewFile("")<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.Diary(&D)<Tab>'.s:QFixHowm_Key.'<Space>  :call QFixHowmOpenDiary()<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.QuickMemo(&U)<Tab>'.s:QFixHowm_Key.'u  :QFixHowmOpenQuickMemo<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.PairLinkFile(&J)<Tab>'.s:QFixHowm_Key.'j  :<C-u>call QFixHowmPairFile()<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.-sep1-			<Nop>'
  exec 'amenu <silent> 41.332 '.s:menu.'.MRU(&M)<Tab>'.s:QFixHowm_Key.g:QFixHowm_Key_SearchMRU.' :<C-u>call QFixHowmMru(0)<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.ListRecent(&L)<Tab>'.s:QFixHowm_Key.g:QFixHowm_Key_SearchRecent.' :<C-u>QFixHowmListRecent<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.ListRecent(&2)<Tab>'.s:QFixHowm_Key.g:QFixHowm_Key_SearchRecentAlt.' :<C-u>QFixHowmListRecentC<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.DiaryList(&O)<Tab>'.s:QFixHowm_Key.'A  :<C-u>call QFixHowmListDiary()<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.ListAll(&A)<Tab>'.s:QFixHowm_Key.'a  :<C-u>call QFixHowmListAllTitle(g:QFixHowm_Title, 0)<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.ListAll-Fast(&E)<Tab>'.s:QFixHowm_Key.'ra  :<C-u>call QFixHowmListAllTitleAlt("reload")<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.FileList(&Q)<Tab>'.s:QFixHowm_Key.'rA  :<C-u>let g:QFixHowm_FileListMax = 0\|QFixHowmFileList<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.-sep2-			<Nop>'
  exec 'amenu <silent> 41.332 '.s:menu.'.FGrep(&S)<Tab>'.s:QFixHowm_Key.'s  :<C-u>call QFixHowmSearchInput("QFixHowm FGrep : ", 0)<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.Grep(&G)<Tab>'.s:QFixHowm_Key.'g  :<C-u>call QFixHowmSearchInput("QFixHowm Grep : ", 1)<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.Vimgrep(&V)<Tab>'.s:QFixHowm_Key.'\\g  :<C-u>call QFixHowmVSearchInput("QFixHowm VGrep : ", 1)<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.-sep3-			<Nop>'
  exec 'amenu <silent> 41.332 '.s:menu.'.Schedule(&Y)<Tab>'.s:QFixHowm_Key.'y  :<C-u>call QFixHowmListReminderCache("schedule")<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.Todo(&T)<Tab>'.s:QFixHowm_Key.'t  :<C-u>call QFixHowmListReminderCache("todo")<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.Rebuild-Schedule(&I)<Tab>'.s:QFixHowm_Key.'ry  :<C-u>call QFixHowmListReminder("schedule")<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.Rebuild-Todo(&K)<Tab>'.s:QFixHowm_Key.'rt  :<C-u>call QFixHowmListReminder("todo")<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.Menu(&,)<Tab>'.s:QFixHowm_Key.',  :<C-u>call QFixHowmOpenMenu()<CR>z.'
  exec 'amenu <silent> 41.332 '.s:menu.'.-sep4-			<Nop>'
  exec 'amenu <silent> 41.332 '.s:menu.'.RandomWalk(&R)<Tab>'.s:QFixHowm_Key.'rr/<F5>  :QFixHowmRandomWalk<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.-sep5-			<Nop>'
  exec 'amenu <silent> 41.332 '.s:menu.'.howm\ Buffer[Local]\ (&B).Date(&D)<Tab>'.s:QFixHowm_Key.'d :call QFixHowmInsertDate("Date")<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.howm\ Buffer[Local]\ (&B).Time(&T)<Tab>'.s:QFixHowm_Key.'T :call QFixHowmInsertDate("Time")<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.howm\ Buffer[Local]\ (&B).-sep50-			<Nop>'
  exec 'amenu <silent> 41.332 '.s:menu.'.howm\ Buffer[Local]\ (&B).Outline(&O)<Tab>'.s:QFixHowm_Key.'o  :call QFixHowmOutline()<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.howm\ Buffer[Local]\ (&B).-sep51-			<Nop>'
  exec 'amenu <silent> 41.332 '.s:menu.'.howm\ Buffer[Local]\ (&B).NewEntry(&1)<Tab>'.s:QFixHowm_Key.'P :QFixMRUMoveCursor top<CR>:call QFixHowmInsertEntry("top")<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.howm\ Buffer[Local]\ (&B).NewEntry(&P)<Tab>'.s:QFixHowm_Key.'p :QFixMRUMoveCursor prev<CR>:call QFixHowmInsertEntry("prev")<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.howm\ Buffer[Local]\ (&B).NewEntry(&N)<Tab>'.s:QFixHowm_Key.'n :QFixMRUMoveCursor next<CR>:call QFixHowmInsertEntry("next")<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.howm\ Buffer[Local]\ (&B).NewEntry(&B)<Tab>'.s:QFixHowm_Key.'N :QFixMRUMoveCursor bottom<CR>:call QFixHowmInsertEntry("bottom")<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.howm\ Buffer[Local]\ (&B).-sep52-			<Nop>'
  exec 'amenu <silent> 41.332 '.s:menu.'.howm\ Buffer[Local]\ (&B).DeleteEntry(&X)<Tab>'.s:QFixHowm_Key.'x  :call QFixHowmDeleteEntry()<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.howm\ Buffer[Local]\ (&B).MoveEntry(&M)<Tab>'.s:QFixHowm_Key.'X  :call QFixHowmDeleteEntry("move")<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.howm\ Buffer[Local]\ (&B).DivideEntry(&W)<Tab>'.s:QFixHowm_Key.'W  :call QFixHowmDivideEntry()<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.-sep6-			<Nop>'
  exec 'amenu <silent> 41.332 '.s:menu.'.Rename-file(&X)<Tab>'.s:QFixHowm_Key.'rn  :<C-u>call QFixHowmRename_()<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.Rename-all-file(&X)<Tab>'.s:QFixHowm_Key.'rN  :<C-u>QFixHowmRenameAll<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.-sep7-			<Nop>'
  exec 'amenu <silent> 41.332 '.s:menu.'.Rebuild-KeywordFile(&F)<Tab>'.s:QFixHowm_Key.'rk  :<C-u>call QFixHowmRebuildKeyword()<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.Rebuild-RandomWalkFile(&F)<Tab>'.s:QFixHowm_Key.'rR  :<C-u>call QFixHowmRebuildRandomWalkFile(g:QFixHowm_RandomWalkFile)<CR>:QFixHowmRandomWalk<CR>'
  exec 'amenu <silent> 41.332 '.s:menu.'.-sepH-			<Nop>'
  exec 'amenu <silent> 41.332 '.s:menu.'.Help(&H)<Tab>'.s:QFixHowm_Key.'H  :<C-u>call QFixHowmHelp()<CR>'
  if MyGrep_MenuBar != 1 && QFixHowm_MenuBar == 1
    exec 'amenu <silent> 40.333 &Tools.-sepend-			<Nop>'
  endif
  let s:QFixHowm_Key = g:QFixHowm_Key . g:QFixHowm_KeyB
endif

function! QFixHowmKeyMap(mapleader, key, cmd)
  exec 'nnoremap <silent> ' . a:mapleader . a:key. ' ' .a:cmd
endfunction

function! QFixHowmFileLink()
  let file = expand("%:p")
  let file = substitute(file, '\\', '/', 'g')
  let hdir = expand(g:howm_dir)
  let hdir = substitute(hdir, '\\', '/', 'g')
  if file =~ '^'.hdir
    let file = 'howm://'.strpart(file, strlen(hdir))
  else
    let hdir = fnamemodify(g:QFixHowm_RelPath, ":p")
    let hdir = substitute(hdir, '\\', '/', 'g')
    if file =~ '^'.hdir
      let file = 'rel://'.strpart(file, strlen(hdir))
    endif
  endif
  let file = g:howm_glink_pattern.file
  exec ':let @"=file'
  silent! exec ':let @*'.'=file'
endfunction

"=============================================================================
" vars
"=============================================================================
"タイトル行識別子
if !exists('g:QFixHowm_Title')
  if exists('howm_title_pattern')
    let g:QFixHowm_Title = howm_title_pattern
  else
    let g:QFixHowm_Title = '='
  endif
endif
"howm検索対象指定
if !exists('g:QFixHowm_SearchHowmFile')
  let g:QFixHowm_SearchHowmFile = '**/*.*'
endif

"スプリットで開く
if !exists('g:QFixHowm_SplitMode')
  let g:QFixHowm_SplitMode = 0
endif
"タブで編集('tab'を設定)
if !exists('QFixHowm_Edit')
  let QFixHowm_Edit = ''
endif
"QFixHowmが自動生成するファイル
if !exists('g:QFixHowm_GenerateFile')
  let g:QFixHowm_GenerateFile = '%Y-%m-%d-%H%M%S.'.g:QFixHowm_FileExt
endif
"検索時にカーソル位置の単語を拾う
if !exists('g:QFixHowm_DefaultSearchWord')
  let g:QFixHowm_DefaultSearchWord = 1
endif
"休日・祝日の予定もエクスポート対象にする
if !exists('g:QFixHowmExportHoliday')
  let g:QFixHowmExportHoliday = 0
endif
"ユーザアクションロックの最大数
if !exists('g:QFixHowm_UserSwActionLockMax')
  let g:QFixHowm_UserSwActionLockMax = 64
endif

" come-from/goto link
if !exists('howm_glink_pattern')
  let howm_glink_pattern = '>>>'
endif
if !exists('howm_clink_pattern')
  let howm_clink_pattern = '<<<'
endif
"howmリンクパターン
if !exists('g:QFixHowm_Link')
  let g:QFixHowm_Link = '\('.g:howm_clink_pattern.'\|'.g:howm_glink_pattern.'\)'
endif
"rel://
if !exists('g:QFixHowm_RelPath')
  let g:QFixHowm_RelPath = g:howm_dir
endif

"最後に使用したhowmファイル
let g:QFixHowm_LastFilename = ''
"howm://を使用する/しない
if !exists('g:QFixHowm_LastFilenameMode')
  let g:QFixHowm_LastFilenameMode = 1
endif
"リンク実験用
if !exists('g:QFixHowm_clink_type')
  let g:QFixHowm_clink_type = ''
endif
let g:QFix_SearchPathEnable = 1

""""""""""""""""""""""""""""""
" 起動/終了
""""""""""""""""""""""""""""""
augroup QFixHowm
  autocmd!
  exec "autocmd FileType ".g:QFixHowm_FileType." call <SID>SetbuflocalSettings()"
  autocmd BufWinEnter quickfix call <SID>QFixHowmBufWinEnter()
  autocmd VimEnter   * call QFixHowmVimEnter()
  autocmd VimLeave   * silent! call delete(s:uricmdfile)
augroup END

"起動時コマンド出力ファイル名
if !exists('g:QFixHowm_VimEnterFile')
  let g:QFixHowm_VimEnterFile = '~/.vimenter.qf'
endif
"起動時コマンド
if !exists('g:QFixHowm_VimEnterCmd')
  let g:QFixHowm_VimEnterCmd=''
endif
"起動時コマンド基準時間
if !exists('g:QFixHowm_VimEnterTime')
  let g:QFixHowm_VimEnterTime='07:00'
endif

function! QFixHowmVimEnter()
  call QFixHowmSetup()
  if exists("*QFixHowmKeymapPost")
    call QFixHowmKeymapPost(s:QFixHowm_Key)
  endif
  if g:QFixHowm_VimEnterCmd == ''
    return
  endif
  let QFixHowmVimEnter = s:QFixHowm_Key.g:QFixHowm_VimEnterCmd
  "今日の日付じゃなかったら起動時コマンド実行
  let file = fnamemodify(g:QFixHowm_VimEnterFile, ':p')
  let ftime = getftime(file)
  let etime = QFixHowmDate2Int(strftime('%Y-%m-%d') . ' '.g:QFixHowm_VimEnterTime)
  if ftime > etime && ftime > -1
    return
  endif

  let ltime = localtime()
  let etime = QFixHowmDate2Int(strftime('%Y-%m-%d', ltime - 24*60*60) . ' '.g:QFixHowm_VimEnterTime)
  let time = ltime - etime -24*60*60 - 1
  if time < 0 && ftime > -1
    return
  endif
  call MyGrepWriteResult(0, file)

  if exists('g:QFixHowm_VimEnterMsg')
    let mes = g:QFixHowm_VimEnterMsg
    let choice = confirm(mes, "&OK\n&Cancel", 1, "Q")
    if choice != 1
      redraw
      return
    endif
  endif
  call feedkeys(QFixHowmVimEnter, 't')
  if exists("*QFixHowmExportSchedule")
    call QFixHowmCmd_ScheduleList()
  endif
endfunction

function! QFixHowmSetup()
  let g:QFixHowm_RandomInit = 1
  let g:HowmHtml_basedir = g:howm_dir
  let g:QFixHowm_GenerateFile = fnamemodify(g:QFixHowm_GenerateFile, ':t:r')
  " デフォルトで .howm は有効にする
  augroup QFixHowmBuffer
    autocmd!
    exec "autocmd BufRead,BufNewFile *.".s:howmsuffix." silent! call QFixHowmInit(1)"
    exec "autocmd BufReadPost        *.".s:howmsuffix." silent! call QFixHowmBufReadPost_()"
    exec "autocmd BufEnter           *.".s:howmsuffix." call QFixHowmBufferBufEnter()"
    exec "autocmd BufEnter           *.".s:howmsuffix." setlocal filetype=".g:QFixHowm_FileType
    exec "autocmd BufWritePre        *.".s:howmsuffix." call QFixHowmInsertLastModified()|call QFixHowmBufWritePre()"
    exec "autocmd BufWritePost       *.".s:howmsuffix." call <SID>QFixHowmBufWritePost_()|call QFixHowmBufWritePost()"
  augroup END
  if g:QFixHowm_HowmMode == 0
    let g:QFixHowm_GenerateFile = g:QFixHowm_GenerateFile . '.' . g:QFixHowm_UserFileExt
    augroup QFixHowmUserAutocmd
      autocmd!
      exec "autocmd BufReadPost        *.".g:QFixHowm_UserFileExt." call QFixHowmBufReadPost_()"
      exec "autocmd BufEnter           *.".g:QFixHowm_UserFileExt." call QFixHowmBufferBufEnter()"
      exec "autocmd BufRead,BufNewFile *.".g:QFixHowm_UserFileExt." call <SID>SetbuflocalSettings()"
      exec "autocmd BufWritePost       *.".g:QFixHowm_UserFileExt." call <SID>QFixHowmInit()"
    augroup END
    return
  endif
  let g:QFixHowm_GenerateFile = g:QFixHowm_GenerateFile . '.' . g:QFixHowm_FileExt
  "再定義
  augroup QFixHowmUserAutocmd
    autocmd!
  augroup END
  augroup QFixHowmBuffer
    if g:QFixHowm_FileExt != s:howmsuffix
      exec "autocmd BufEnter           *.".g:QFixHowm_FileExt." call QFixHowmBufferBufEnter()"
      exec "autocmd BufRead,BufNewFile *.".g:QFixHowm_FileExt." call QFixHowmInit(1)"
      exec "autocmd BufEnter           *.".g:QFixHowm_FileExt." call QFixHowmFileType('%')"
      exec "autocmd BufReadPost        *.".g:QFixHowm_FileExt." silent! call QFixHowmBufReadPost_()"
      exec "autocmd BufWritePre        *.".g:QFixHowm_FileExt." call QFixHowmInsertLastModified()|call QFixHowmBufWritePre()"
      exec "autocmd BufWritePost       *.".g:QFixHowm_FileExt." call <SID>QFixHowmBufWritePost_()|call QFixHowmBufWritePost()"
    endif
  augroup END
endfunction

" Howmのイニシャライズ
let s:QFixHowm_Init  = 0
function! QFixHowmInit(...)
  call QFixHowmInitMru(a:0)
  if s:QFixHowm_Init
    return 0
  endif
  call QFixHowmLoadKeyword()
  call QFixHowmHighlight()
  let dir = expand(g:howm_dir)
  if isdirectory(dir) == 0
    let mes = printf("!!!Create howm_dir? (%s)", dir)
    let choice = confirm(mes, "&Yes\n&Cancel", 2, "W")
    if choice == 1
      call mkdir(dir, 'p')
    else
      return 1
    endif
  endif

  let s:QFixHowm_Init = 1
  let title = substitute(g:SubWindow_Title, '^.*/', '', '')
  let cmd = ':call ToggleQFixSubWindow()'

  for i in range(g:QFixHowm_howm_dir_Max, 2,-1)
    if g:QFixHowm_howm_dir_Max < 2
      break
    endif
    if !exists('g:howm_dir'.i)
      continue
    endif
    exec 'let hdir = g:howm_dir'.i
    let hdir = expand(hdir)
    if isdirectory(hdir) == 0
      continue
    endif
    if exists('g:howm_fileencoding'.i)
      exec 'let l:howm_fileencoding = g:howm_fileencoding'.i
    else
      let l:howm_fileencoding = g:howm_fileencoding
    endif
    if g:howm_fileencoding != l:howm_fileencoding
      let g:QFixHowm_ForceEncoding = 0
      break
    endif
  endfor
  "乱数
  if g:QFixHowm_RandomWalkMode == 1
    if has('unix') && !has('win32unix')
      silent! call libcallnr("", "srand", localtime())
    else
      silent! call libcallnr("msvcrt.dll", "srand", localtime())
    endif
  endif
endfunction

"BufReadPost
function! QFixHowmBufReadPost_()
  if !IsQFixHowmFile('%')
    return
  endif
  if g:QFixHowm_NoBOM && &bomb
    set nobomb
    write!
  endif
  if g:QFixHowm_HowmMode == 0 && fnamemodify(expand('%'), ':e') == g:QFixHowm_UserFileExt
    " return
  endif
  if &readonly == 0 && g:QFixHowm_ForceEncoding && &fenc != g:howm_fileencoding
    let saved_ft = &filetype
    let saved_syn = &syntax
    exec 'edit! ++enc='.g:howm_fileencoding.' ++ff='.g:howm_fileformat
    if &readonly
      edit!
      let mes= "Invalid howm_fileencording (".&fenc.")\nConvert to ".g:howm_fileencoding."?"
      let choice = g:QFixHowm_ForceEncoding == 2 ? 1 : confirm(mes, "&Yes\n&Cancel", 1, "W")
      if choice == 1
        exec 'set fenc='.g:howm_fileencoding
        exec 'set ff='.g:howm_fileformat
        if g:QFixHowm_NoBOM && &bomb
          set nobomb
        endif
        write!
      endif
    endif
    let &filetype=saved_ft
    let &syntax=saved_syn
  endif
  call QFixHowmBufReadPost()
endfunction

"BufReadPost
silent! function QFixHowmBufReadPost()
  call QFixHowmDecode()
endfunction

"BufWritePre
silent! function QFixHowmBufWritePre()
  call QFixHowmEncode()
endfunction

"BufWritePost
function! s:QFixHowmBufWritePost_()
  if !IsQFixHowmFile('%')
    return
  endif
  if getfsize(expand('%:p')) <= 0
    call delete(expand('%:p'))
    return
  endif
  call QFixHowmAddKeyword()
endfunction

function! QFixMRUVimLeave()
  if s:QFixHowm_Init
    call QFixHowmInitMru(0)
  endif
endfunction

"BufWritePost
silent! function QFixHowmBufWritePost()
  call QFixHowmDecode()
endfunction

silent! function QFixHowmEncode()
endfunction

silent! function QFixHowmDecode()
endfunction

"=============================================================================
" Quickfix
"=============================================================================
function! s:QFixHowmBufWinEnter(...)
  if &buftype != 'quickfix'
    return
  endif
  "シンタックスファイルで定義されているhowmSchedule等の色を読み込む
  let name=g:QFixHowm_FileType
  exec "runtime! syntax/" . name . ".vim syntax/" . name . "/*.vim"
  setlocal ft=qf
  call QFixHowmQFsyntax()
  exec "silent! nnoremap <silent> <buffer> " . s:QFixHowm_Key . ". :call QFixHowmMoveTodayReminder()<CR>"
  exec "silent! nnoremap <silent> <buffer> " . g:QFixHowm_Key . ". :call QFixHowmMoveTodayReminder()<CR>"
  if a:0
    return
  endif

  if exists("*QFixHowmExportSchedule")
    nnoremap <buffer> <silent> !  :call QFixHowmCmd_ScheduleList()<CR>
    vnoremap <buffer> <silent> !  :call QFixHowmCmd_ScheduleList('visual')<CR>
  endif
  nnoremap <buffer> <silent> @  :call QFixHowmCmd_AT('normal')<CR><ESC>
  vnoremap <buffer> <silent> @  :call QFixHowmCmd_AT('visual')<CR><ESC>
  nnoremap <buffer> <silent> &  :call QFixHowmCmd_AT('user')<CR><ESC>:call QFixHowmUserCmd(g:QFixHowm_MergeList)<CR>
  vnoremap <buffer> <silent> &  :call QFixHowmCmd_AT('user visual')<CR><ESC>:call QFixHowmUserCmd(g:QFixHowm_MergeList)<CR>
  nnoremap <buffer> <silent> x  :call QFixHowmCmd_X()<CR>
  " vnoremap <buffer> <silent> x  :call QFixHowmCmd_X()<CR>
  nnoremap <buffer> <silent> X  :call QFixHowmCmd_X('move')<CR>
  " vnoremap <buffer> <silent> X  :call QFixHowmCmd_X('move')<CR>
  nnoremap <buffer> <silent> S  :call QFixHowmCmd_Sort()<CR>
  nnoremap <buffer> <silent> D  :call QFixHowmCmd_RD('Delete')<CR>
  vnoremap <buffer> <silent> D  :call QFixHowmCmd_RD('Delete')<CR>
  nnoremap <buffer> <silent> R  :call QFixHowmCmd_RD('Remove')<CR>
  vnoremap <buffer> <silent> R  :call QFixHowmCmd_RD('Remove')<CR>
  nnoremap <buffer> <silent> #  :call QFixHowmCmd_Replace('remove')<CR>
  nnoremap <buffer> <silent> %  :call QFixHowmCmd_Replace('title')<CR>
  nnoremap <buffer> <silent> <F5>  :QFixHowmRandomWalk<CR>
  exec 'silent! nnoremap <buffer> <silent> '.s:QFixHowm_Key.'w :MyGrepWriteResult<CR>'
endfunction

" 今日の日付まで移動
function! QFixHowmMoveTodayReminder()
  let save_cursor = getpos('.')
  call cursor(1,1)
  let str = strftime('['.s:hts_date)
  let str = g:QFixHowm_ShowTodayLineStr . ' ' . str
  let [lnum, col] = searchpos(str, 'cW')
  if lnum == 0 && col == 0
    call setpos('.', save_cursor)
    return
  endif
  call cursor(lnum, 1)
  exec 'normal! zz'
endfunction

""""""""""""""""""""""""""""""
"QFix拡張コマンド
"""""""""""""""""""""""""""""
silent! function QFixHowmUserCmd(list)
  "Quickfixウィンドウを開く
  QFixCopen
endfunction

function! QFixHowmCmd_X(...) range
  let lnum = QFixGet('lnum')
  let qf = QFixGetqflist()
  if len(qf) == 0
    return
  endif
  let l = line('.') - 1
  let lnum = qf[l]['lnum']
  let file = bufname(qf[l]['bufnr'])
  let mes = "!!!Delete Entry!"
  if a:0 > 0
    let mes = "!!!Move Entry!"
  endif
  let choice = confirm(mes, "&Yes\n&Cancel", 2, "W")
  if choice == 1
    call QFixHowmEditFile(file)
    call cursor(lnum, 1)
    if a:0 > 0
      call QFixHowmDeleteEntry('move')
    else
      call QFixHowmDeleteEntry()
    endif
    let g:QFixHowm_WriteUpdateTime = 0
    write!
    wincmd p
    let qf = QFixGetqflist()
    call remove(qf, l)
    call QFixSetqflist(qf)
    call cursor(l+1, 1)
  endif
endfunction

function! QFixHowmDeleteEntry(...)
  let [text, startline, endline] = QFixMRUGet('title', '%', line('.'))
  silent exec startline.','.endline.'d'
  call cursor(startline, 1)
  if &hidden == 0
    let g:QFixHowm_WriteUpdateTime = 0
    write!
  endif
  if a:0
    let l:howm_filename = g:howm_filename
    let g:howm_filename = matchstr(g:howm_filename, '^.*/').g:QFixHowm_GenerateFile
    call QFixHowmCreateNewFile()
    let g:howm_filename = l:howm_filename
    silent! %delete _
    silent! 0put
    silent! $delete _
    call cursor(1,1)
    call feedkeys("\<ESC>")
    let g:QFixHowm_WriteUpdateTime = 0
    write!
  endif
endfunction

function! QFixHowmCmd_Sort()
  let mes = 'Sort type? (r:reverse)+(m:mtime, n:name, t:text, h:howmtime) : '
  let pattern = input(mes, '')
  if pattern =~ 'r\?h'
    call QFixPclose()
    let qf = QFixHowmSort('howmtime', 0)
    if pattern =~ 'r.*'
      let qf = reverse(qf)
    endif
    call QFixSetqflist(qf)
    let g:QFix_SelectedLine = 1
    let g:QFix_SearchResult = []
    QFixCopen
    redraw|echo 'Sorted by howmtime.'
    return
  endif
  return QFixSortExec(pattern)
endfunction

function! QFixHowmCmd_RD(cmd) range
  let loop = 1
  if a:firstline != a:lastline
    if a:cmd == 'Delete'
      let mes = "!!!Delete file(s)"
    else
      let mes = "!!!Remove to (~howm_dir)"
    endif
    let choice = confirm(mes, "&Yes\n&Cancel", 2, "W")
    if choice != 1
      return
    endif
    let loop = a:lastline - a:firstline + 1
  endif
  let save_cursor = getpos('.')
  let qf = QFixGetqflist()
  let idx = line('.')-1
  for index in range(1, loop)
    let file = QFixGet('file')
    if a:firstline == a:lastline
      if a:cmd == 'Delete'
        let mes = "!!! Delete : ".file
      else
        let mes = "!!! Remove to (".g:howm_dir.") : ".file
      endif
      let choice = confirm(mes, "&Yes\n&Cancel", 2, "W")
    endif
    if choice != 1
      return
    endif
    let dst = g:howm_dir.'/'.fnamemodify(file, ':t')
    let dst = fnamemodify(dst, ':p')
    let prevPath = escape(getcwd(), ' ')
    if a:cmd == 'Delete'
      call delete(file)
    else
      call rename(file, dst)
    endif
    call remove(qf, idx)
    silent! exec 'normal! '. line('.')+1 .'Gzz'
  endfor
  setlocal modifiable
  silent! exec 'normal! 9999999999u'
  setlocal nomodifiable
  call QFixSetqflist(qf)
  QFixCopen
  call setpos('.', save_cursor)
  call QFixPclose()
endfunction

function! QFixHowmCmd_Replace(mode)
  QFixCclose
  let prevPath = escape(getcwd(), ' ')
  let h = g:QFix_Height
  let idx = 0
  let sq = QFixGetqflist()
  for d in sq
    let ret = s:QFixHowmListRecentReplaceTitle(bufname(d.bufnr), '', d.lnum)
    if ret[0] != ''
      let d.text = ret[0]
      if a:mode != 'title'
        let d.lnum = ret[1]
      endif
    endif
  endfor
  let g:QFix_Height = h
  if a:mode == 'remove'
    let max = len(sq)-1
    for idx in range(max, 1, -1)
      for j in range(0, idx-1)
        if sq[idx]['lnum'] == sq[j]['lnum'] && sq[idx]['text'] == sq[j]['text'] && bufname(sq[idx]['bufnr']) == bufname(sq[j]['bufnr'])
          call remove(sq, idx)
          break
        endif
      endfor
    endfor
  endif
  let s:UseTitleFilter = 1
  call QFixHowmTitleFilter(sq)
  cexpr ''
  call QFixSetqflist(sq)
  silent exec 'lchdir ' . prevPath
  if empty(sq)
    QFixCclose
    redraw | echo 'QFixHowm : Not found!'
  else
    QFixCopen
  endif
  call cursor(1, 1)
  return
endfunction

""""""""""""""""""""""""""""""
"連結表示で使用するセパレータ
if !exists('g:QFixHowm_MergeEntrySeparator')
  let g:QFixHowm_MergeEntrySeparator = "=========================="
endif
"連結表示をスクラッチバッファとして使用する
if !exists('g:QFixHowm_MergeEntryMode')
  let g:QFixHowm_MergeEntryMode = 1
endif
"連結表示を固定名単一バッファで使用する
"空白なら連結表示は複数作成される
if !exists('g:QFixHowm_MergeEntryName')
  let g:QFixHowm_MergeEntryName = ''
endif

function! QFixHowmCmd_AT(mode) range
  let save_cursor = getpos('.')
  let g:QFixMRU_Disable = 1

  let flist = []
  let llist = []
  let g:QFixHowm_MergeList = []

  let cnt = line('$')
  let g:QFixHowm_UserCmdline = 0
  let firstline = a:firstline
  if a:firstline != a:lastline || a:mode =~ 'visual'
    let cnt = a:lastline - a:firstline + 1
  else
    let g:QFixHowm_UserCmdline = a:firstline
    let firstline = 1
  endif

  for n in range(cnt)
    call cursor(firstline+n, 1)
    let file = QFixGet('file')
    call add(flist, file)
    let lnum = QFixGet('lnum')
    call add(llist, lnum)
  endfor

  QFixCclose
  let rez = []
  let h = g:QFix_Height

  for n in range(cnt)
    let [entry, flnum, llnum] = QFixMRUGet('entry', flist[n], llist[n])
    let str = g:QFixHowm_MergeEntrySeparator.g:howm_glink_pattern.' '. flist[n]
    let entry = insert(entry, str, 1)
    let rez = extend(rez, entry)
  endfor

  let g:QFix_Height = h
  if g:QFixHowm_MergeEntryName != ''
    let lname = strftime(g:QFixHowm_MergeEntryName)
  else
    let lname = strftime(g:QFixHowm_GenerateFile)
  endif
  let file = escape(g:howm_dir.'/'.lname, ' ')
  if a:mode =~ 'user'
    let g:QFix_SelectedLine = save_cursor[1]
    let g:QFixMRU_Disable = 0
    return
  endif
  if g:QFixHowm_MergeEntryName != ''
    if filewritable(file) == 1
      call QFixHowmEditFile(file)
    else
      call QFixEditFile(lname)
    endif
  else
    call QFixEditFile(lname)
  endif
  silent! exec 'setlocal filetype='.g:QFixHowm_FileType
  if g:QFixHowm_MergeEntryMode
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
  endif
  silent! %delete _
  call setline(1, rez)
  call cursor(1, 1)
  call QFixHowmHighlight()
  QFixCopen
  call setpos('.', save_cursor)
  exec 'normal! z.'
  wincmd p
  let g:QFixMRU_Disable = 0
endfunction

""""""""""""""""""""""""""""""
"Quickfixウィンドウの定義部分を取り出す
function! QFixHowmCmd_ScheduleList(...) range
  if !exists("*QFixHowmExportSchedule")
    return
  endif
  let prevPath = escape(getcwd(), ' ')

  let firstline = 1
  let cnt = line('$')
  if a:firstline != a:lastline || a:0 > 0
    let cnt = a:lastline - a:firstline + 1
    let firstline = a:firstline
  endif

  let schlist = []
  let l:QFixHowm_Title = '\d\+| '.s:sch_dateT.s:sch_Ext
  let save_cursor = getpos('.')
  for n in range(cnt)
    call cursor(firstline+n, 1)
    let qfline = getline('.')
    if qfline !~ l:QFixHowm_Title
      continue
    endif
    let holiday = g:QFixHowm_ReminderHolidayName
    if exists('g:QFixHowm_UserHolidayName')
      let holiday = g:QFixHowm_ReminderHolidayName . '\|' .g:QFixHowm_UserHolidayName
    endif
    let hdreg = '^'.s:sch_dateTime .'@ '.g:QFixHowm_DayOfWeekReg.' \?'.'\('.holiday.'\)'
    if qfline =~ holiday && g:QFixHowmExportHoliday == 0
      continue
    endif
    let file = QFixGet('file')
    let lnum = QFixGet('lnum')
    let ddat = {"qffile": file, "qflnum": lnum, "qfline": qfline}
    call add(schlist, ddat)
  endfor
  call setpos('.', save_cursor)

  QFixCclose
  let h = g:QFix_Height
  silent! exec 'split '
  silent! exec 'silent! edit '.s:howmtempfile
  setlocal buftype=nofile
  setlocal noswapfile
  setlocal bufhidden=hide
  setlocal nobuflisted
  for d in schlist
    call s:QFixHowmMakeScheduleList(d)
  endfor
  silent! exec 'silent! edit '.s:howmtempfile
  setlocal buftype=nofile
  silent! bd!
  let g:QFix_Height = h
  if schlist != []
    call s:QFixHowmParseScheduleList(schlist)
    call QFixHowmExportSchedule(schlist)
  else
    QFixCopen
  endif
  return schlist
endfunction

function! s:QFixHowmMakeScheduleList(sdic)
  setlocal modifiable
  silent! %delete _
  let file = a:sdic['qffile']
  let lnum = a:sdic['qflnum']
  let tmpfile = escape(file, ' #%')
  if g:QFixHowm_ForceEncoding
    silent! exec '0read ++enc='.g:howm_fileencoding.' ++ff='.g:howm_fileformat.' '.tmpfile
  else
    silent! exec '0read '.tmpfile
  endif
  silent! $delete _
  call cursor(lnum,1)
  let a:sdic['orgline'] = getline(lnum)

  let head = QFixHowmGetTitleSearchRegxp()

  let start = lnum+1
  let end   = search(head, 'nW')-1
  if end == -1
    let end = line('$')
  endif
  let a:sdic['Description'] = getline(start, end)
  return a:sdic['Description']
endfunction

function! s:QFixHowmParseScheduleList(sdic)
  for d in a:sdic
    let pattern = '.*'.s:sch_dateT.s:sch_Ext.'\d*\s*'.g:QFixHowm_DayOfWeekReg.'\?\s*'
    let d['Summary'] = substitute(d['qfline'], pattern, '', '')
    let pattern = '\['.s:sch_date
    let d['StartDate'] = strpart(matchstr(d['qfline'], pattern), 1)
    let d['StartDate'] = substitute(d['StartDate'], '[/]', '-', 'g')
    let pattern = '\['.s:sch_date . ' '. s:sch_time
    let d['StartTime'] = strpart(matchstr(d['qfline'], pattern), 12)
    let pattern = '&\['.s:sch_date
    let d['EndDate'] = strpart(matchstr(d['orgline'], pattern), 2)
    let d['EndDate'] = substitute(d['EndDate'], '[/]', '-', 'g')
    let pattern = '&\['.s:sch_date.' '. s:sch_time
    let d['EndTime'] = strpart(matchstr(d['orgline'], pattern), 13)
    if d['EndTime'] == ''
      let d['EndDate'] = QFixHowmAddDate(d['EndDate'], g:QFixHowm_EndDateOffset)
    endif

    let pattern = s:sch_dateCmd
    let d['define']  = strpart(matchstr(d['orgline'], pattern), 0)
    let pattern = ']'.s:sch_cmd
    let d['command'] = strpart(matchstr(d['orgline'], pattern), 1)
    let d['duration'] = matchstr(d['command'], '\d\+$')

    let duration = d['duration']
    let cmd = d['command'][0]
    if duration == ''
      if cmd == '@'
        "@のデフォルトオプションは表示だけに関係する
        let duration = 1
      elseif cmd == '!'
        let duration = g:QFixHowm_ReminderDefault_Deadline
      elseif cmd == '-'
        let duration = g:QFixHowm_ReminderDefault_Reminder
      elseif cmd == '+'
        let duration = g:QFixHowm_ReminderDefault_Todo
      elseif cmd == '~'
        let duration = g:QFixHowm_ReminderDefault_UD
      else
        let duration = 0
      endif
    else
      "@のオプションは0,1の継続期間が同じ
      if cmd == '@'
        if duration < 2
          let duration = 1
        endif
      endif
    endif
    "-の継続期間は duration+1日
    if cmd == '-'
      let duration = duration + g:QFixHowm_ReminderOffset
    endif
    let d['duration'] = duration
  endfor
endfunction

function! QFixHowmAddDate(date, param)
  let day = QFixHowmDate2Int(a:date) + a:param
  let sttime = (day - g:DateStrftime) * 24 * 60 * 60 + g:QFixHowm_ST * (60 * 60)
  let str = strftime(s:hts_date, sttime)
  return matchstr(str, s:sch_date)
endfunction

"=============================================================================
" MRU
"=============================================================================
"MRU最大表示数
if !exists('g:QFixHowm_MruFileMax')
  let g:QFixHowm_MruFileMax = 20
endif
"MRUはhowm_dir以下しか表示しない
if !exists('g:QFixHowm_MruMode')
  let g:QFixHowm_MruMode = 'directory'
endif

let s:mruprg = 0
function! QFixHowmInitMru(mode)
  if s:mruprg || a:mode
    return
  endif
  let l:QFixHowm_Title = escape(g:QFixHowm_Title, g:QFixHowm_EscapeTitle)
  if !has_key(g:QFixMRU_Title, s:howmsuffix)
    let g:QFixMRU_Title[s:howmsuffix]       = '^'.l:QFixHowm_Title.' '
  endif
  if !has_key(g:QFixMRU_Title, g:QFixHowm_FileExt)
    let g:QFixMRU_Title[g:QFixHowm_FileExt] = '^'.l:QFixHowm_Title.' '
  endif
  if g:QFixMRU_state == 0
    let file = g:QFixMRU_Filename
    let dir = g:howm_dir
    if exists('g:QFixMRU_RootDir')
      let dir = g:QFixMRU_RootDir
    elseif exists('g:QFixHowm_RootDir')
      let dir = g:QFixHowm_RootDir
    endif
    call QFixMRURead(file, dir, '/merge')
  endif
  let s:mruprg = 1
endfunction

function! QFixHowmMru(mode)
  call QFixHowmInitMru(0)
  call QFixMRUWrite(0)
  if a:mode
    call QFixMRUClear()
  endif
  if count
    let g:QFixHowm_MruFileMax = count
  endif
  let dirmode = g:QFixHowm_MruMode == 'directory'
  let dir = dirmode ? g:howm_dir : ''
  let sq = QFixMRUGetList()
  let idx = 0
  if !dirmode
    for d in sq
      if !IsQFixHowmFile(d['filename']) && d['filename'] !~ g:QFixHowm_FileExt
        call remove(sq, idx)
        continue
      endif
      let idx += 1
    endfor
  endif
  call QFixPclose()
  let sq = QFixMRUPrecheck(sq, g:QFixHowm_MruFileMax, dir)
  let g:QFix_SearchPath = g:howm_dir
  call QFixSetqflist(sq)
  call QFixCopen('', 1)
  call cursor(1, 1)
endfunction

function! QFixMRURegisterCheck(mru)
  let file = a:mru['filename']
  let file = fnamemodify(file, ':t')
  let lnum  = a:mru['lnum']
  let text  = a:mru['text']
  let reg = '\('.s:howmsuffix.'\|'.g:QFixHowm_FileExt.'\)'
  if file =~ 'Sche-.*' || file =~ 'Menu-00-00-000000\.'.reg || file =~ '__submenu__\.'.reg
    return 1
  endif
  return 0
endfunction

silent! function QFixHowmLoadMru(...)
endfunction
silent! function QFixHowmSaveMru(...)
endfunction

"=============================================================================
" アクションロック
"=============================================================================
"日付のデフォルトアクションロック
if !exists('g:QFixHowm_DateActionLockDefault')
  let g:QFixHowm_DateActionLockDefault = 1
endif
"リストアクションロック
if exists('g:QFixHowmSwitchListActionLock')
  "SwitchListActionLockのドキュメントミス対応
  let g:QFixHowm_SwitchListActionLock = g:QFixHowmSwitchListActionLock
endif
if !exists('g:QFixHowm_SwitchListActionLock')
  let g:QFixHowm_SwitchListActionLock = ['{ }', '{*}', '{-}']
endif
"ユーザーマクロアクションロックの識別子
if !exists('g:QFixHowm_MacroActionPattern')
  let g:QFixHowm_MacroActionPattern = '<|>'
endif
"ユーザーマクロアクションのキーマップ
if !exists('g:QFixHowm_MacroActionKey')
  let g:QFixHowm_MacroActionKey = 'M'
endif
let s:QFixHowmALSPat = ''

"アクションロック用ハイライト
let g:QFixHowm_keyword = ''
function! QFixHowmHighlight()
  if !IsQFixHowmFile('%')
    return
  endif
  if &syntax == ''
    return
  endif
  silent! syntax clear actionlockKeyword
  if g:QFixHowm_keyword != ''
    exe 'syntax match actionlockKeyword display "\V'.g:QFixHowm_keyword.'"'
  endif
endfunction

"アクションロック実行
"TODO:strを取得しない形に修正する
function! QFixHowmActionLock()
  let RegisterBackup = [@0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @/, @", @"]
  if has('gui_running')
    silent! let RegisterBackup[12] = @*
  endif
  let s:QFixHowmMA = 0
  let str = QFixHowmActionLockStr()
  if s:QFixHowmMA
    exec 'normal '. str
  elseif str == "\<CR>"
    silent exec "normal! \<CR>"
  elseif str == "\<ESC>"
  else
    let str = substitute(str, "\<CR>", "|", "g")
    let str = substitute(str, "|$", "", "")
    silent exec str
  endif
  for n in range(10)
    silent! exec 'let @'.n.'=RegisterBackup['.n.']'
  endfor
  let @/ = RegisterBackup[10]
  let @" = RegisterBackup[11]
  if has('gui_running')
    silent! let @* = RegisterBackup[12]
  endif
  return
endfunction

function! QFixHowmActionLockStr()
  let save_cursor = getpos('.')
  call setpos('.', save_cursor)
  let ret = QFixHowmMacroAction()
  if ret != "\<CR>"
    let s:QFixHowmMA = 1
    return ret
  endif
  call setpos('.', save_cursor)
  let ret = QFixHowmOpenCursorline()
  if ret == 1
    return "\<ESC>"
  elseif ret == -1
    let glink = g:howm_glink_pattern
    let file = matchstr(getline('.'), glink.'.*$', '', '')
    let file = substitute(file, glink.'\s*', '', '')
    if filereadable(expand(file))
      let file = escape(file, '\')
      return ":exec 'call QFixHowmEditFile(\"".file."\")'\<CR>"
      return "\<ESC>"
    endif
    silent exec 'normal! gf'
    return "\<ESC>"
  endif
  call setpos('.', save_cursor)
  let text = getline('.')
  let stridx = match(text, g:QFixHowm_Link)
  if stridx > -1 && col('.') > stridx
    let pattern = matchstr(text, g:QFixHowm_Link.'\s*.*$')
    let pattern = substitute(pattern, '^'.g:QFixHowm_Link.'\s*', '', '')
    let s:QFixHowmALSPat = pattern
    call QFixHowmActionLockSearch(0)
    return "\<ESC>"
  endif
  call setpos('.', save_cursor)
  let ret = QFixHowmDateActionLock()
  if ret != "\<CR>"
    return ret
  endif
  call setpos('.', save_cursor)
  let ret = QFixHowmTimeActionLock()
  if ret != "\<CR>"
    return ret
  endif
  call setpos('.', save_cursor)
  if col('.') < 36 && getline('.') =~ '^'.s:sch_dateT.s:sch_Ext
    let ret = QFixHowmSwitchActionLock(g:QFixHowm_ScheduleSwActionLock, 1)
    if ret != "\<CR>"
      return ret
    endif
  endif
  call setpos('.', save_cursor)
  let ret = QFixHowmRepeatDateActionLock()
  if ret != "\<CR>"
    return ret
  endif
  call setpos('.', save_cursor)
  let ret = QFixHowmKeywordLinkSearch()
  if ret != "\<CR>"
    return ret
  endif
  call setpos('.', save_cursor)
  let ret = QFixHowmSwitchActionLock(g:QFixHowm_SwitchListActionLock)
  if ret != "\<CR>"
    return ret
  endif
  call setpos('.', save_cursor)
  let ret = QFixHowmSwitchActionLock(['{_}'])
  if ret != "\<CR>"
    return ret
  endif
  call setpos('.', save_cursor)
  if exists('g:QFixHowm_UserSwActionLock')
    let ret = QFixHowmSwitchActionLock(g:QFixHowm_UserSwActionLock)
    if ret != "\<CR>"
      return ret
    endif
  endif
  call setpos('.', save_cursor)

  for i in range(2, g:QFixHowm_UserSwActionLockMax)
    if !exists('g:QFixHowm_UserSwActionLock'.i)
      continue
    endif
    call setpos('.', save_cursor)
    exec 'let action = '.'g:QFixHowm_UserSwActionLock'.i
    if action != []
      let ret = QFixHowmSwitchActionLock(action)
      if ret != "\<CR>"
        return ret
      endif
    endif
  endfor
  call setpos('.', save_cursor)
  if getline('.') =~ '^'.s:sch_dateT.s:sch_Ext
    call cursor('.', 1)
    let ret = QFixHowmRepeatDateActionLock()
    if ret != "\<CR>"
      return ret
    endif
  endif
  call setpos('.', save_cursor)
  return "\<CR>"
endfunction

"Wikiスタイルリンクの扱い
if !exists('g:QFixHowm_Wiki')
  let g:QFixHowm_Wiki = 0
endif
"キーワードリンク検索
function! QFixHowmKeywordLinkSearch()
  let save_cursor = getpos('.')
  let l:QFixHowm_keyword = g:QFixHowm_keyword
  let col = col('.')
  let lstr = getline('.')

  for word in g:QFixHowm_KeywordList
    let len = strlen(word)
    let pos = match(lstr, '\V'.word)
    if pos == -1 || col < pos+1
      continue
    endif
    let str = strpart(lstr, col-len, 2*len)
    if matchstr(str, '\V'.word) == word
      let s:QFixHowmALSPat = word
      if g:QFixHowm_Wiki > 0
        let link = word
        if g:QFixHowm_Wiki == 1
          let file = g:howm_dir
          if exists('g:QFixHowm_WikiDir')
            let file = g:howm_dir . '/'.g:QFixHowm_WikiDir
          endif
          let file = file .'/'.link.'.'.g:QFixHowm_FileExt
          call QFixEditFile(file)
        elseif g:QFixHowm_Wiki == 2
          let cmd = ':e '
          let subdir = vimwiki#current_subdir()
          call vimwiki#open_link(cmd, subdir.link)
        endif
        return "\<ESC>"
      endif
      call QFixHowmActionLockSearch(0)
      return "\<ESC>"
    endif
  endfor
  return "\<CR>"
endfunction

"アクションロック用サーチ
function! QFixHowmActionLockSearch(regmode, ...)
  let g:MyGrep_Regexp = a:regmode
  let pattern = s:QFixHowmALSPat
  if a:0 > 0
    let pattern = input(a:1, pattern)
  endif
  if pattern == ''
    return "\<CR>"
  endif
  call histadd('@', pattern)
  call QFixHowmListAll(pattern, 0)
endfunction

"ユーザーマクロのアクションロック
let s:QFixHowm_MacroActionCmd = ''
function! QFixHowmMacroAction()
  if g:QFixHowm_MacroActionKey == '' || g:QFixHowm_MacroActionPattern == ''
    return "\<CR>"
  endif
  if expand('%:t') !~ g:QFixHowm_Menufile
    " return "\<CR>"
  endif
  let text = getline('.')
  if text !~ g:QFixHowm_MacroActionPattern
    return "\<CR>"
  endif
  let text = substitute(text, '.*'.g:QFixHowm_MacroActionPattern, "", "")
  let s:QFixHowm_MacroActionCmd = text
  exec "nmap <silent> " . s:QFixHowm_Key . g:QFixHowm_MacroActionKey . " " . ":<C-u>:QFixCclose<CR>" .substitute(s:QFixHowm_MacroActionCmd, '^\s*', '', '')
  return s:QFixHowm_Key . g:QFixHowm_MacroActionKey
endfunction

"=============================================================================
"QFixHowmコマンド
"=============================================================================
"バッファローカル設定
function! s:SetbuflocalSettings()
  exec "silent! nnoremap <unique> <silent> <buffer> ".s:QFixHowm_Key."n :QFixMRUMoveCursor next<CR>:call QFixHowmInsertEntry('next')<CR>"
  exec "silent! nnoremap <unique> <silent> <buffer> ".s:QFixHowm_Key."N :QFixMRUMoveCursor bottom<CR>:call QFixHowmInsertEntry('bottom')<CR>"
  exec "silent! nnoremap <unique> <silent> <buffer> ".s:QFixHowm_Key."p :QFixMRUMoveCursor prev<CR>:call QFixHowmInsertEntry('prev')<CR>"
  exec "silent! nnoremap <unique> <silent> <buffer> ".s:QFixHowm_Key."P :QFixMRUMoveCursor top<CR>:call QFixHowmInsertEntry('top')<CR>"
  exec "silent! nnoremap <unique> <silent> <buffer> ".s:QFixHowm_Key."x :call QFixHowmDeleteEntry()<CR>"
  exec "silent! nnoremap <unique> <silent> <buffer> ".s:QFixHowm_Key."X :call QFixHowmDeleteEntry('move')<CR>"
  exec "silent! nnoremap <unique> <silent> <buffer> ".s:QFixHowm_Key."W :call QFixHowmDivideEntry()<CR>"
  exec "silent! vnoremap <unique> <silent> <buffer> ".s:QFixHowm_Key."W :call QFixHowmDivideEntry()<CR>"
  if !IsQFixHowmFile('%')
    return
  endif
  if g:QFixHowm_Folding
    setlocal nofoldenable
    setlocal foldmethod=expr
    if g:QFixHowm_WildCardChapter
      setlocal foldexpr=QFixHowmFoldingLevel(v:lnum)
    else
      exec "setlocal foldexpr=getline(v:lnum)=~'".g:QFixHowm_FoldingPattern."'?'>1':'1'"
    endif
  endif
  call QFixHowmHighlight()

  if g:QFixHowm_UseAutoLinkTags
    exec "silent! nnoremap <silent> <buffer> <C-]> :<C-u>if !QFixHowmOpenClink() <Bar> exec 'normal! <C-]>' <Bar> endif<CR>"
    exec "silent! vnoremap <silent> <buffer> <C-]> :<C-u>if !QFixHowmOpenClink() <Bar> exec 'normal! <C-]>' <Bar> endif<CR>"
    exec "silent! nnoremap <silent> <buffer> g<C-]> :<C-u>if !QFixHowmOpenClink() <Bar> exec 'normal! <C-]>' <Bar> endif<CR>"
    exec "silent! vnoremap <silent> <buffer> g<C-]> :<C-u>if !QFixHowmOpenClink() <Bar> exec 'normal! <C-]>' <Bar> endif<CR>"
  endif
  exec "silent! nnoremap <unique> <silent> <buffer> ".s:QFixHowm_Key."w :call QFixHowmBufLocalSave()<CR>"
  exec "silent! nnoremap <unique> <silent> <buffer> ".s:QFixHowm_Key."S :call QFixHowmInsertLastModified(1)<CR>"
  exec "silent! nnoremap <unique> <silent> <buffer> ".s:QFixHowm_Key."rs :call QFixHowmSortEntry('normal')<CR>"
  exec "silent! nnoremap <unique> <silent> <buffer> ".s:QFixHowm_Key."rS :call QFixHowmSortEntry('reverse')<CR>"
  if exists("*QFixHowmLocalKeymapPost")
    call QFixHowmLocalKeymapPost(s:QFixHowm_Key)
  endif
endfunction

function! QFixHowmBufLocalSave()
  let g:QFixHowm_WriteUpdateTime = 0
  if &buftype == 'nofile'
    setlocal buftype=
  endif
  write!
endfunction

function! QFixHowmDivideEntry() range
  let g:QFixMRU_Disable = 1
  let fline = a:firstline
  let lline = a:lastline
  if fline == lline
    let fline = 1
    let lline = line('$')
  endif
  let h = g:QFix_Height
  let cnt = 0
  let [text, fline, lline] = QFixMRUGet('entry', '%', fline)
  let first = fline
  while 1
    call s:QFixHowmSaveDividedEntry(text, cnt)
    let cnt = cnt + 1
    if lline == line('$') || lline > a:lastline
      break
    endif
    let fline = lline + 1
    call cursor(fline, 1)
    let [text, fline, lline] = QFixMRUGet('entry', '%', fline)
    echo text
  endwhile
  let last = lline
  exec first.','.last.'delete _'
  let g:QFix_Height = h
  let g:QFixMRU_Disable = 0
  redraw | echo "QFixHowm : Completed."
endfunction

function! s:QFixHowmSaveDividedEntry(text, cnt)
  let g:QFixHowm_WriteUpdateTime = 0
  let l:howm_filename = strftime(g:QFixHowm_GenerateFile, localtime()+a:cnt)
  let file = escape(g:howm_dir.'/'.l:howm_filename, ' ')
  let dir = matchstr(file, '.*/')
  let dir = substitute(dir, '/$', '', '')
  let opt = '++enc=' . g:howm_fileencoding . ' ++ff=' . g:howm_fileformat . ' '
  silent exec 'new '. opt . file

  silent exec 'setlocal fenc=' . g:howm_fileencoding
  silent exec 'setlocal ff='. g:howm_fileformat
  silent! %delete _
  silent! 0put=a:text
  call cursor(line('$'), 1)
  while 1
    if getline('.') !~ '^$' || line('.') == 1
      break
    endif
    delete _
  endwhile
  call setline(line('$')+1, [''])
  call cursor(1, 1)
  silent exec 'w! '
  silent exec 'bd'
  let g:QFixHowm_WriteUpdateTime = 1
endfunction

""""""""""""""""""""""""""""""
" ファイル
""""""""""""""""""""""""""""""
"howmテンプレート
if !exists('g:QFixHowm_Template')
  let g:QFixHowm_Template = [
    \ "%TITLE% %TAG%",
    \ "%DATE%",
    \ ""
  \]
endif
"howmテンプレート(カーソル移動)
if !exists('g:QFixHowm_Cmd_NewEntry')
  let g:QFixHowm_Cmd_NewEntry = "$a"
endif
"mkdテンプレート
if !exists('g:QFixHowm_Template_mkd')
  let g:QFixHowm_Template_mkd = [
    \ "%TITLE% %TAG%",
    \ ""
  \]
endif
"mkdテンプレート(カーソル移動)
if !exists('g:QFixHowm_Cmd_NewEntry_mkd')
  let g:QFixHowm_Cmd_NewEntry_mkd = "$a"
endif
if !exists('g:QFixHowm_DefaultTag')
  let g:QFixHowm_DefaultTag = ''
endif
"クイックメモファイル名
if !exists('g:QFixHowm_QuickMemoFile')
  let g:QFixHowm_QuickMemoFile = 'Qmem-00-0000-00-00-000000.'.g:QFixHowm_FileExt
endif
"日記メモファイル名
if !exists('g:QFixHowm_DiaryFile')
  let g:QFixHowm_DiaryFile = ''.fnamemodify(g:howm_filename, ':h').'/%Y-%m-%d-000000.'.g:QFixHowm_FileExt
endif
"日記検索対象指定
if !exists('g:QFixHowm_SearchDiaryFile')
  let g:QFixHowm_SearchDiaryFile = '**/*/[12]*-000000.*'
endif
"日記検索高速表示
if !exists('g:QFixHowm_SearchDiaryMode')
  let g:QFixHowm_SearchDiaryMode = 0
endif
"ペアリンクされたhowmファイルの保存場所
if !exists('g:QFixHowm_PairLinkDir')
  let g:QFixHowm_PairLinkDir = 'pairlink'
endif
"ペアリンクファイル名をフルパスで扱う
if !exists('g:QFixHowm_PairLinkMode')
  let g:QFixHowm_PairLinkMode = 0
endif

let g:QFix_FileOpenMode = 0

" 新規howmファイル作成
function! QFixHowmCreateNewFile(...)
  if QFixHowmInit(1)
    return
  endif
  let file = g:howm_dir.'/'. strftime(g:howm_filename)
  let file = fnamemodify(file, ':p')
  let mode = ''
  if g:QFixHowm_SplitMode
    let mode = 'split'
  endif

  let winnr = QFixWinnr()
  if winnr < 1
    split
    let mode = ''
  elseif mode == 'split'
  else
    exec winnr.'wincmd w'
  endif

  let g:QFixHowm_LastFilename=''
  let l:MyOpenVim_ExtReg = '\.'.g:QFixHowm_FileExt.'$'.'\|\.'.s:howmsuffix.'$'
  if g:QFixHowm_OpenVimExtReg != ''
    let l:MyOpenVim_ExtReg = l:MyOpenVim_ExtReg.'\|'.g:QFixHowm_OpenVimExtReg
  endif
  if expand('%') =~ l:MyOpenVim_ExtReg
    let lfile = expand('%:p')
    if g:QFixHowm_LastFilenameMode == 1
      silent! let lfile = substitute(lfile, escape(g:howm_dir, '\\').'[/\\]\?', 'howm://', '')
    endif
    let g:QFixHowm_LastFilename = ' ' . g:howm_glink_pattern . ' ' . lfile
  endif
  if a:0 > 0
    if a:1 == ''
      let pattern = input('howm filename : ', '')
      if pattern != ''
        let file = g:howm_dir .'/'. fnamemodify(strftime(g:howm_filename), ':h') .'/'
        let file = file.pattern
      endif
    else
      let file = g:howm_dir.'/'.a:1
    endif
    let file = fnamemodify(file, ':p')
    let ereg = g:QFixHowm_FileExt . '\|'.s:howmsuffix
    if fnamemodify(file, ':e') !~ ereg
      let file = file .'.'. g:QFixHowm_FileExt
    endif
  endif
  if filewritable(file) == 1
    call QFixHowmEditFile(file, mode)
    return
  endif
  if mode == 'split'
    split
  endif
  let dir = fnamemodify(file, ':h')
  if isdirectory(dir) == 0
    call mkdir(dir, 'p')
  endif
  let opt = '++enc=' . g:howm_fileencoding . ' ++ff=' . g:howm_fileformat . ' '
  if g:QFix_FileOpenMode == 0
    silent exec g:QFixHowm_Edit.'edit '. opt . escape(file, ' %#')
  else
    silent exec g:QFixHowm_Edit.'new '. opt . escape(file, ' %#')
  endif
  if len(g:QFixHowm_Template) == 0
    return
  endif
  if QFixHowmInsertEntry('New')
    return
  endif
  if g:QFixHowm_HowmMode == 0 && fnamemodify(file, ':e') == g:QFixHowm_UserFileExt
    return
  endif
  call QFixHowmHighlight()
  return
endfunction

silent! function QFixHowmCreateNewFileWithTag(tag)
  let title = g:QFixHowm_Title. ' '. a:tag
  call QFixHowmCreateNewFile()
  stopinsert
  call setline(1, [title])
  call cursor(1, 1)
  exec 'normal! 0w'
endfunction

function! QFixHowmInsertEntry(cmd, ...)
  if !IsQFixHowmFile('%')
    return 1
  endif
  let ext = fnamemodify(expand('%'), ':e')
  if ext == s:howmsuffix || ext == g:QFixHowm_FileExt
    let QFixHowm_Template = deepcopy(g:QFixHowm_Template)
  elseif exists('g:QFixHowm_Template_'.ext)
    exec 'let QFixHowm_Template = ' . 'deepcopy(g:QFixHowm_Template_'.ext.')'
  else
    return 1
  endif
  if len(QFixHowm_Template) == 0
    return 1
  endif
  call add(QFixHowm_Template, "")
  call map(QFixHowm_Template, 'substitute(v:val, "%TITLE%", g:QFixHowm_Title, "g")')
  let tag = g:QFixHowm_DefaultTag == '' ? '' : g:QFixHowm_DefaultTag . ' '
  call map(QFixHowm_Template, 'substitute(v:val, "%TAG%", tag, "g")')
  let date = strftime("[".s:hts_dateTime."]")
  call map(QFixHowm_Template, 'substitute(v:val, "%DATE%", date, "g")')
  call map(QFixHowm_Template, 'substitute(v:val, "%LASTFILENAME%", g:QFixHowm_LastFilename, "g")')
  call map(QFixHowm_Template, 'strftime(v:val)')
  if a:cmd == 'New'
    silent! call setline(1, QFixHowm_Template)
    $delete _
    call cursor(1, 1)
  endif
  let nl = ""
  let len = len(QFixHowm_Template)
  let l = line('.')
  if a:cmd =~ 'next'
    if getline(line('.')) != ''
      silent! put=nl
    endif
    silent! put=QFixHowm_Template
    call cursor(line('.')-len+2, 1)
  elseif a:cmd == 'prev'
    silent! -1put=QFixHowm_Template
    call cursor(line('.')-len+2, 1)
  elseif a:cmd == 'top'
    silent! -1put=QFixHowm_Template
    call cursor(1, 1)
  elseif a:cmd == 'bottom'
    if getline(line('$')) != ''
      silent! put=nl
    endif
    silent! $put=QFixHowm_Template
    call cursor(line('.')-len+2, 1)
  endif
  let cmd = g:QFixHowm_Cmd_NewEntry
  let saved_ve = &virtualedit
  silent setlocal virtualedit+=onemore
  silent! exec 'normal! '. cmd
  if cmd =~ '\CA$'
    exec 'normal! l'
    startinsert!
  elseif cmd =~ '\Ca$'
    exec 'normal! l'
    startinsert
  elseif cmd =~ '\CI$'
    exec 'normal! ^'
    startinsert
  elseif cmd =~ '\Ci$'
    startinsert
  endif
  silent exec 'setlocal virtualedit='.saved_ve
  return 0
endfunction

function! QFixHowmReadfile(file)
  let mfile = fnamemodify(a:file, ':p')
  if bufloaded(mfile) "バッファが存在する場合
    let glist = getbufline(mfile, 1, '$')
  else
    let glist = readfile(mfile)
    let from = g:howm_fileencoding
    let to   = &enc
    call map(glist, 'iconv(v:val, from, to)')
  endif
  return glist
endfunction

"ファイルが存在するので開く
"追加パラメータが'split'ならスプリットで開く
function! QFixHowmEditFile(file,...)
  let file = fnamemodify(a:file, ':p')
  let mode = ''
  if a:0
    let mode = a:1
  endif
  let winnum = bufwinnr(file)
  if winnum == winnr()
    return
  endif
  if winnum != -1
    exec winnum . 'wincmd w'
    return
  endif

  let winnr = QFixWinnr()
  if winnr < 1 || mode == 'split'
    split
  else
    exec winnr.'wincmd w'
  endif

  let dir = fnamemodify(file, ':h')
  if isdirectory(dir) == 0
    call mkdir(dir, 'p')
  endif
  let opt = ''
  exec g:QFixHowm_Edit.'edit ' . opt . escape(file, ' %#')
endfunction

"クイックメモを開く
command! -count QFixHowmOpenQuickMemo if count|silent! exec 'let g:QFixHowm_QMF = g:QFixHowm_QuickMemoFile'.count|endif|call QFixHowmOpenQuickMemo(g:QFixHowm_QMF)
let g:QFixHowm_QMF = g:QFixHowm_QuickMemoFile
function! QFixHowmOpenQuickMemo(qfname)
  if QFixHowmInit(1)
    return
  endif
  let hfile = strftime(a:qfname)
  let sfile = g:howm_dir.'/'.hfile
  let sfile = expand(sfile)

  let winnr = bufwinnr(bufnr(sfile))
  if filereadable(sfile)
    if winnr > -1
      exec winnr.'wincmd w'
    else
      let winnr = QFixWinnr()
      if winnr < 1 || g:QFixHowm_SplitMode
        split
      else
        exec winnr.'wincmd w'
      endif
      exe "edit " . escape(sfile, ' %#')
    endif
  else
    call QFixHowmCreateNewFile(hfile)
  endif
endfunction

" 日記を開く
function! QFixHowmOpenDiary()
  let file = g:QFixHowm_DiaryFile
  if g:QFixHowm_HowmMode == 0 && g:QFixHowm_UserFileType == 'vimwiki'
    let file = VimwikiGet('diary_rel_path').'%Y-%m-%d.'.g:QFixHowm_UserFileExt
  endif
  call QFixHowmOpenQuickMemo(file)
endfunction

"特定ファイルにペアリングされたhowmファイルを開く
function! QFixHowmPairFile()
  if IsQFixHowmFile('%')
    return
  endif
  let ext = expand('%:e')
  let file = expand('%:t')
  if g:QFixHowm_PairLinkMode
    let file = substitute(fnamemodify(file, ':p'), '[\/:*?"<>|]', '%', 'g')
  endif
  if ext != g:QFixHowm_FileExt
    let file = file .'.'.g:QFixHowm_FileExt
  endif

  let file = g:QFixHowm_PairLinkDir.'/'.file

  let glist = []
  if !filereadable(expand(g:howm_dir).'/'.file)
    let str = g:QFixHowm_Title . ' >>> ' . substitute(expand('%:p'), '\\', '/', 'g')
    call add(glist, str)
    let type = g:QFixHowm_FileType
    if ext !~ s:howmsuffix.'\|'.g:QFixHowm_FileExt
      if &filetype != '' && &filetype != g:QFixHowm_FileType
        let type = &filetype.'.'.g:QFixHowm_FileType
      endif
    endif
    call add(glist, printf('vim: set ft=%s :', type))
  endif
  call QFixHowmEditFile(g:howm_dir.'/'.file)
  if len(glist)
    exec 'setlocal ft='.type
    let glist += getline(2, '$')
    call setline(1, glist)
    if line('.') == 1
      call cursor('1', col('$'))
    endif
  endif
endfunction

""""""""""""""""""""""""""""""
" help
""""""""""""""""""""""""""""""
let s:QFixHowm_Helpfile = 'QFixHowmHelp.'.s:howmsuffix
function! QFixHowmHelp()
  if g:QFixHowm_MenuDir == ''
    let hdir = escape(expand(g:howm_dir), ' ')
  else
    let hdir = escape(expand(g:QFixHowm_MenuDir), ' ')
  endif
  silent! exec 'split '
  silent! exec 'edit ' . hdir .'/'. s:QFixHowm_Helpfile
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  call setline(1, g:QFixHowmHelpList)
  silent! exec 'setlocal filetype='.g:QFixHowm_FileType
  call cursor(1,1)
endfunction

""""""""""""""""""""""""""""""
"サブウィンドウ
""""""""""""""""""""""""""""""
"サブウィンドウを出す方向
if !exists('g:SubWindow_Dir')
  let g:SubWindow_Dir = "topleft vertical"
endif
"サブウィンドウのファイル名
if !exists('g:SubWindow_Title')
  let g:SubWindow_Title = '~/__submenu__.'.s:howmsuffix
endif
"サブウィンドウのサイズ
if !exists('g:SubWindow_Width')
  let g:SubWindow_Width = 30
endif
"サブウィンドウを常駐モードにする。
if !exists('g:QFix_PermanentWindow')
  let g:QFix_PermanentWindow = []
endif

"サブウィンドウのトグル
function! ToggleQFixSubWindow()
  let bufnum = bufnr(g:SubWindow_Title)
  let winnum = bufwinnr(g:SubWindow_Title)
  if bufnum != -1 && winnum != -1
    exec "bd ". bufnum
  else
    call s:OpenQFixSubWin()
  endif
endfunction

function! s:OpenQFixSubWin()
  let winnum = bufwinnr(g:SubWindow_Title)
  if winnum != -1
    if winnr() != winnum
      exec winnum . 'wincmd w'
    endif
    return
  endif
  let windir = g:SubWindow_Dir
  let winsize = g:SubWindow_Width

  let bufnum = bufnr(g:SubWindow_Title)
  if bufnum == -1
    let wcmd = g:SubWindow_Title
  else
    let wcmd = '+buffer' . bufnum
  endif
  exec 'silent! ' . windir . ' ' . winsize . 'split ' . wcmd
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal nowrap
  setlocal foldcolumn=0
  setlocal nolist
  setlocal winfixwidth
  nnoremap <silent> <buffer> q :close<CR>
endfunction

""""""""""""""""""""""""""""""
"ランダムウォーク
""""""""""""""""""""""""""""""
"ランダム表示保存ファイル
if !exists('g:QFixHowm_RandomWalkFile')
  let g:QFixHowm_RandomWalkFile = '~/.howm-random'
endif
"乱数生成方法(うまく動かない場合 0 に)
if !exists('g:QFixHowm_RandomWalkMode')
  let g:QFixHowm_RandomWalkMode = 1
endif
"ランダム表示保存ファイル更新間隔
if !exists('g:QFixHowm_RandomWalkUpdate')
  let g:QFixHowm_RandomWalkUpdate = 10
endif
"ランダム表示数
if !exists('g:QFixHowm_RandomWalkColumns')
  let g:QFixHowm_RandomWalkColumns = 10
endif
command! -count QFixHowmRandomWalk :call QFixHowmRandomWalk()

let s:randomresulttime = 0
let g:howm_random_columns = g:QFixHowm_RandomWalkColumns
let g:QFixHowm_RandomInit = 1

function! QFixHowmRandomWalk(...)
  if bufwinnr(g:QFix_Win)
    let h = winheight(bufwinnr(g:QFix_Win))
    if g:QFixHowm_RandomWalkColumns < h
      let g:QFixHowm_RandomWalkColumns = h
    endif
  endif
  if QFixHowmInit()
    return
  endif
  let prevPath = escape(getcwd(), ' ')
  if a:0 == 0
    redraw|echo 'QFixHowm : Random Walk...'
  endif
  if count && a:0 == 0
    let g:QFixHowm_RandomWalkColumns = count
  endif
  let len = g:QFixHowm_RandomWalkColumns
  if a:0
    let len = a:1
  endif

  call QFixPclose()
  let file = expand(g:QFixHowm_RandomWalkFile)
  let rfile = file
  if has('unix')
    let rfile = rfile . '-u'
  endif
  silent! exec 'lchdir ' . escape(expand(g:howm_dir), ' ')
  if exists('g:QFixHowm_RootDir')
    silent exec 'lchdir ' . escape(expand(g:QFixHowm_RootDir), ' ')
  endif
  if !filereadable(rfile)
    call QFixHowmRebuildRandomWalkFile(file)
  elseif g:QFixHowm_RandomWalkUpdate && localtime() - getftime(rfile) > g:QFixHowm_RandomWalkUpdate * 24*60*60
    call QFixHowmRebuildRandomWalkFile(file)
  endif
  if s:randomresulttime != getftime(rfile) || g:QFixHowm_RandomInit
    let g:QFixHowm_RandomInit = 0
    let g:QFix_SelectedLine = 1
    call s:QFixHowmRandomListInit()
    let s:randomresulttime = getftime(rfile)
  endif
  let result = s:QFixHowmRandomList(s:randomresult, len)
  " MyQFixライブラリを使用可能にする。
  if a:0 == 0
    call QFixSetqflist(result)
    call QFixEnable(g:howm_dir)
  endif
  silent exec 'lchdir ' . prevPath
  if a:0
    return result
  endif
  QFixCopen
endfunction

"ランダムウォークリスト作成
function! s:QFixHowmRandomListInit()
  let file = expand(g:QFixHowm_RandomWalkFile)
  let rfile = file
  if has('unix')
    let rfile = rfile . '-u'
  endif
  let prevPath = escape(getcwd(), ' ')
  let list = QFixHowmReadfile(rfile)
  let s:randomresultpath = expand(substitute(list[0], '|.*$', '',''))
  if exists('g:QFixHowm_RootDir')
    let s:randomresultpath = expand(g:QFixHowm_RootDir)
  endif
  let s:randomresultpath = substitute(s:randomresultpath, '\\', '/', 'g')
  call remove(list, 0)
  silent exec 'lchdir ' . escape(s:randomresultpath, ' ')
  let rexclude = ''
  if exists('g:QFixHowm_RandomWalkExclude')
    let rexclude = g:QFixHowm_RandomWalkExclude
  endif
  if exists('g:QFixMRU_IgnoreFile')
    let exclude = g:QFixMRU_IgnoreFile
  endif
  let head = expand(g:howm_dir)
  let head = substitute(head, '\\', '/', 'g')
  let s:randomresult = []
  for r in list
    let file = substitute(r, '|.*', '', '')
    let file = s:randomresultpath.'/'.file
    let file = substitute(file, '\\', '/', 'g')
    let text = substitute(r, '^[^|]\+|', '', '')
    let lnum = matchstr(text, '^\d\+')
    let text = substitute(text, '^[^|]\+|', '', '')
    let res = {'filename' : file, 'lnum' : lnum, 'text' : text}
    call add(s:randomresult, res)
  endfor
  if exclude != ''
    call filter(s:randomresult, "v:val['text'] !~ '".exclude."'")
  endif
  if rexclude != ''
    call filter(s:randomresult, "v:val['text']     !~ '".rexclude."'")
    call filter(s:randomresult, "v:val['filename'] !~ '".rexclude."'")
  endif
  silent exec 'lchdir ' . prevPath
  return
endfunction

function! s:QFixHowmRandomList(list, len)
  let len  = a:len
  let list = deepcopy(a:list)

  let head = expand(g:howm_dir)
  let head = substitute(head, '\\', '/', 'g')
  call filter(list, "v:val['filename'] =~ '".head."'")
  let result = []
  while 1
    let range = len(list)
    if range <= 0 || len <= 0
      break
    endif
    let r = QFixHowmRandom(range)
    let file = list[r]['filename']
    let readable = 1
    if match(file, head) == 0
      let readable = filereadable(file)
      if readable
        call add(result, list[r])
        let len -= 1
      endif
    endif
    call remove(list, r)
    if !readable
      call filter(list, "match(v:val['filename'], file)")
    endif
  endwhile
  return result
endfunction

"乱数発生
silent! function QFixHowmRandom(range)
  "unixでは echo $RANDOM を使用するべきかも
  "Windowsの echo %RANDOM%はsystem(cmd)だと種が初期化されるので加工する必要がある。
  if g:QFixHowm_RandomWalkMode == 1
    if has('unix') && !has('win32unix')
      let r = libcallnr("", "rand", -1) % a:range
    else
      let r = libcallnr("msvcrt.dll", "rand", -1) % a:range
    endif
    return r
  endif
  let r = reltimestr(reltime())
  let r = substitute(r, '^.*\.','','') % a:range
  "生命、宇宙、そして万物についての（究極の疑問の）答えを使用する
  sleep 42m
  return r
endfunction

"ランダムウォークファイル再作成
function! QFixHowmRebuildRandomWalkFile(file)
  let rfile = expand(a:file)
  if has('unix')
    let rfile = rfile . '-u'
  endif
  let l:howm_dir = g:howm_dir
  if exists('g:QFixHowm_RootDir')
    let g:howm_dir = g:QFixHowm_RootDir
  endif
  let g:QFix_UseLocationList = 1
  let g:QFix_Disable = 1
  let saved_sq = QFixGetqflist()
  call QFixHowmListAllTitle_(g:QFixHowm_Title, 0)
  let sq = QFixGetqflist()
  cal QFixSetqflist(saved_sq)
  let g:QFix_UseLocationList = 0
  let g:QFix_Disable = 0
  let prevPath = escape(getcwd(), ' ')
  let dir = g:howm_dir
  let result = []
  call add(result, dir)
  silent exec 'lchdir ' . escape(expand(dir), ' ')
  for d in sq
    let file = bufname(d['bufnr'])
    let file = fnamemodify(file, ':.')
    let text = iconv(d['text'], &enc, g:howm_fileencoding)
    let res = file.'|'.d['lnum'].'|'.text
    call add(result, res)
  endfor
  call writefile(result, rfile)
  let g:howm_dir = l:howm_dir
  silent exec 'lchdir ' . prevPath
endfunction

""""""""""""""""""""""""""""""
" 検索
""""""""""""""""""""""""""""""
"最近更新ファイル検索日数
if !exists('g:QFixHowm_RecentDays')
  let g:QFixHowm_RecentDays = 5
endif
",aコマンドはキャッシュ版を使用
if !exists('QFixHowm_TitleListCache')
  let QFixHowm_TitleListCache = 0
endif
",aコマンドでソートを使用する/しない
if !exists('g:QFixHowm_AllTitleSearchSort')
  let g:QFixHowm_AllTitleSearchSort = 0
endif
"QFixHowm_RecentMode > 0で howmタイムスタンプソートを使用する/しない
if !exists('g:QFixHowm_HowmTimeStampSort')
  let g:QFixHowm_HowmTimeStampSort = 0
endif
"タイトル検索のエスケープパターン
if !exists('g:QFixHowm_EscapeTitle')
  let g:QFixHowm_EscapeTitle = '[]~*.\#'
endif
"Wikiスタイルリンク定義も検索で一番上にする
if !exists('g:QFixHowm_WikiLink_AtTop')
  let g:QFixHowm_WikiLink_AtTop = 0
endif

" タイトルgrep用正規表現の取得
function! QFixHowmGetTitleGrepRegxp(...)
  let title = escape(g:QFixHowm_Title, g:QFixHowm_EscapeTitle)
  let pattern = '^'.escape(g:QFixHowm_Title, g:QFixHowm_EscapeTitle)
  let regxp = QFixMRUGetTitleGrepRegxp(g:QFixHowm_FileExt)
  let pattern = regxp != '' ? regxp : pattern
  if g:QFixHowm_HowmMode == 0
    let regxp = QFixMRUGetTitleGrepRegxp(g:QFixHowm_UserFileExt)
    let pattern = regxp != '' ? regxp : pattern
  endif
  if pattern =~ '[^\s]$'
    if !exists('g:mygrepprg') || g:mygrepprg == 'internal' || g:mygrepprg == ''
      let t = '\\([^'.g:QFixHowm_Title.']\\|$\\)'
    elseif g:mygrepprg == 'findstr'
      let t = '[^'.g:QFixHowm_Title.']'
    else
      let t = '\([^'.g:QFixHowm_Title.']\|$\)'
    endif
    let pattern = substitute(pattern, '$', t, '')
  else
    if !exists('g:mygrepprg') || g:mygrepprg == 'internal' || g:mygrepprg == ''
      let pattern = pattern . '\\(\\s\\|$\\)'
    elseif g:mygrepprg == 'findstr'
      let pattern = pattern . '[ \t]'
    else
      let pattern = pattern . '([ 	]|$)'
    endif
  endif
  return pattern
endfunction

" タイトル検索用正規表現の取得
function! QFixHowmGetTitleSearchRegxp(...)
  let pattern = QFixHowmGetTitleGrepRegxp()
  let regxp = QFixMRUGetTitleRegxp(g:QFixHowm_FileExt)
  let pattern = regxp != '' ? regxp : pattern
  if g:QFixHowm_HowmMode == 0
    let regxp = QFixMRUGetTitleRegxp(g:QFixHowm_UserFileExt)
    let pattern = regxp != '' ? regxp : pattern
  endif
  if pattern =~ ' $'
    let pattern = substitute(pattern, ' $', '\\(\\s\\|$\\)', '')
  else
    let pattern = substitute(pattern, '$', '\\([^'.g:QFixHowm_Title.']\\|$\\)', '')
  endif
  return pattern
endfunction

"検索のフロントエンド
function! QFixHowmVSearchInput(title, isRegxp, ...)
  let g:MyGrep_UseVimgrep = 1
  let mode = ''
  if a:0
    let mode = 'visual'
  endif
  return QFixHowmSearchInput(a:title, a:isRegxp, mode)
endfunction

function! QFixHowmSearchInput(title, isRegxp, ...)
  let pattern = expand("<cword>")
  let text = getline('.')
  let link = match(text, '\('.g:howm_clink_pattern.'\|'.g:howm_glink_pattern.'\)')
  if link > -1 && col('.') > link
    let pattern = matchstr(text, '\('.g:howm_clink_pattern.'\|'.g:howm_glink_pattern.'\)\s*.*$')
    let pattern = substitute(pattern, '^\('.g:howm_clink_pattern.'\|'.g:howm_glink_pattern.'\)\s*', '', '')
  endif
  if a:0 && a:1 == 'visual'
    exec 'normal! vgvy'
    let pattern = input(a:title, @0)
  else
    if g:QFixHowm_DefaultSearchWord < 1
      let pattern = ''
    endif
    if g:QFixHowm_DefaultSearchWord < 0
      let g:QFixHowm_DefaultSearchWord = 1
    endif
    let pattern = input(a:title, pattern)
  endif
  if pattern == ''
    let MyGrep_UseVimgrep = 0
    return
  endif
  call QFixHowmSearch(pattern, a:isRegxp)
endfunction

function! QFixHowmSearch(pattern, isRegxp)
  let g:MyGrep_Regexp = a:isRegxp
  call QFixHowmListAll(a:pattern, 0)
endfunction

function! MultiHowmDirGrep(pattern, dir, filepattern, enc, addflag, ...)
  let pattern     = a:pattern
  let filepattern = a:filepattern
  let hdir        = expand(a:dir)
  let enc         = a:enc
  let addflag     = a:addflag
  let basename    = 'g:howm_dir'
  if a:0 > 0
    let basename = a:1
  endif
  for i in range(g:QFixHowm_howm_dir_Max, 2, -1)
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
    let l:howm_fileencoding = enc
    if exists('g:howm_fileencoding'.i)
      exec 'let l:howm_fileencoding = g:howm_fileencoding'.i
    endif
    if g:howm_fileencoding != l:howm_fileencoding
      let g:QFixHowm_ForceEncoding = 0
    endif
    call MyGrep(pattern, hdir, filepattern, l:howm_fileencoding, addflag)
    let addflag = 1
  endfor
  return addflag
endfunction

function! QFixHowmListAllTitle(pattern, days, ...)
  if QFixHowmInit()
    return
  endif
  let pattern = a:pattern
  if g:QFixHowm_TitleListCache
    call QFixHowmListAllTitleAlt()
  else
    call QFixHowmListAllTitle_(pattern, a:days)
  endif
endfunction

function! QFixHowmListAllTitle_(pattern, days, ...)
  let pattern = QFixHowmGetTitleGrepRegxp()
  let s:QFixHowm_FileListSort = g:QFixHowm_AllTitleSearchSort
  if a:0
    let s:QFixHowm_FileListSort = a:1
  endif
  let s:UseTitleFilter = 1
  call QFixHowmListAll(pattern, a:days)
endfunction

let s:QFixHowm_FileListSort = 1
"patternをhowm_dirから検索して、現在からdays日以内を登録。
"days=0ならすべて。
function! QFixHowmListAll(pattern, days)
  if QFixHowmInit()
    return
  endif
  let attop = 0
  let addflag = 0
  let pattern = a:pattern
  if match(pattern, '\C[A-Z]') != -1
    let g:MyGrep_Ignorecase = 0
  endif
  if a:pattern =~ '^'.g:howm_glink_pattern
    let attop = 1
    let pattern = substitute(pattern, '^'.g:howm_glink_pattern, '', '')
  endif
  if a:pattern =~ '^'.g:howm_clink_pattern
    let attop = 1
    let pattern = substitute(pattern, '^'.g:howm_clink_pattern, '', '')
  endif
  let @/=pattern
  let prevPath = escape(getcwd(), ' ')
  let l:howm_dir = expand(g:howm_dir)
  let gpattern = pattern
  if a:days
    let g:MyGrep_FileListWipeTime = localtime() - a:days*24*60*60
  endif
  QFixCclose
  redraw|echo 'QFixHowm : Searching...'
  let addflag = MultiHowmDirGrep(gpattern, l:howm_dir, g:QFixHowm_SearchHowmFile, g:howm_fileencoding, addflag)
  call MyGrep(gpattern, l:howm_dir, g:QFixHowm_SearchHowmFile, g:howm_fileencoding, addflag)
  let wlist = []
  let clist = []
  if s:QFixHowm_FileListSort == -1
    let sq = reverse(QFixGetqflist())
    let s:QFixHowm_FileListSort = 1
  elseif s:QFixHowm_FileListSort == 0
    let sq = QFixHowmSort('mtime', a:days)
    let s:QFixHowm_FileListSort = 1
  else
    if g:QFixHowm_RecentMode && g:QFixHowm_HowmTimeStampSort
      let sq = QFixHowmSort('howmtime', a:days)
    else
      let sq = QFixHowmSort('mtime', a:days)
    endif
    let attop = 1
    let l:QFixHowm_Title = QFixHowmGetTitleSearchRegxp()
    if a:pattern =~ '\'.l:QFixHowm_Title
      let attop = 0
    endif
      "<<<自身は必ず先頭へ
    let tpattern = pattern
    if a:0 == 0
      let tpattern = escape(pattern, '[].*~\#')
    endif
    if attop == 1
      let idx = 0
      for d in sq
        if d.text =~ '\[\[\s*'.tpattern.'\s*\]\]'
          if g:QFixHowm_WikiLink_AtTop > 0
            let top = remove(sq, idx)
            call add(wlist, top)
            continue
          endif
        endif
        if d.text =~ g:howm_clink_pattern.'\s*'.tpattern
          let top = remove(sq, idx)
          call add(clist, top)
          continue
        endif
        let idx = idx + 1
      endfor
    endif
  endif
  let sq = clist + wlist + sq
  call QFixHowmTitleFilter(sq)
  call QFixSetqflist(sq)
  if empty(sq)
    redraw | echo 'QFixHowm : Not found!'
  else
    QFixCopen
    redraw|echo ''
  endif
  if g:MyGrep_ErrorMes != ''
    echohl ErrorMsg
    redraw | echo g:MyGrep_ErrorMes
    echohl None
  endif
  if g:QFix_PreviewUpdatetime == 0
    call QFixPreview()
  endif
endfunction

"ソート関数、days日前より古いのは破棄
function! QFixHowmSort(cmd, days, ...)
  let lasttime = localtime() - a:days*24*60*60
  let cmd = a:cmd
  redraw|echo 'QFixHowm : ('.cmd.')'.' Sorting...'
  if a:days == 0
    let lasttime = 0
  endif
  let save_qflist = QFixGetqflist()
  if a:0
    let save_qflist = a:1
  endif
  let bname = ''
  let bmtime = 0
  let idx = 0
  if cmd == 'howmtime'
    if g:QFixHowm_RecentMode > 0
      let pattern = '^'.s:sch_dateTime
      if g:QFixHowm_RecentMode == 3 || g:QFixHowm_RecentMode == 4
        let pattern = s:Recentmode_Date
      endif
      let mode = a:0
      call s:QFixHowmSetTtime(save_qflist, pattern, mode)
      let save_qflist = sort(save_qflist, "QFixHowmCompareTime")
      let g:QFix_Sort = 'mtime'
      let g:QFix_SelectedLine = 1
      redraw | echo ''
      return save_qflist
    endif
    let cmd = 'mtime'
  endif
  if cmd == 'mtime'
    for d in save_qflist
      if bname == bufname(d.bufnr)
        let d['mtime'] = bmtime
      else
        let d['mtime'] = getftime(bufname(d.bufnr))
      endif
      let bname  = bufname(d.bufnr)
      let bmtime = d.mtime
      if d.mtime < lasttime
        call remove(save_qflist, idx)
      else
        let idx = idx + 1
      endif
    endfor
    let save_qflist = sort(save_qflist, "QFixCompareTime")
    let g:QFix_Sort = 'mtime'
  elseif cmd == 'ttime'
    if g:QFixHowm_RecentMode > 0
      let pattern = s:sch_dateTime
      if g:QFixHowm_RecentMode == 3 || g:QFixHowm_RecentMode == 4
        let pattern = s:Recentmode_Date
      endif
      for d in save_qflist
        let t = matchstr(d.text, pattern)
        let t = substitute(t, '[^0-9]', '', 'g')
        let d['time'] = t
      endfor
      let save_qflist = sort(save_qflist, "QFixHowmCompareTime")
    else
      let save_qflist = sort(save_qflist, "QFixCompareText")
      let save_qflist = reverse(save_qflist)
    endif
    let g:QFix_Sort = 'mtime'
  elseif cmd == 'text'
    let save_qflist = sort(save_qflist, "QFixCompareText")
    let g:QFix_Sort = 'text'
  elseif cmd == 'name'
    let save_qflist = sort(save_qflist, "QFixCompareName")
    let g:QFix_Sort = 'name'
  endif
  let g:QFix_SelectedLine = 1
  redraw | echo ''
  return save_qflist
endfunction

let s:prevgepname = ''
function! s:QFixHowmSetTtime(qf, pattern, mode)
  if g:QFixHowm_RecentMode == 0
    return a:qf
  endif
  let idx = 0
  let s:prevgepname = ''
  for d in a:qf
    if a:mode
      let file = d['filename']
    else
      let file = bufname(d.bufnr)
    endif
    let file = substitute(file, '\\', '/', 'g')
    let t = s:GetPatternInEntry(file, a:pattern, d.lnum)
    let d['time'] = t
    let idx = idx + 1
  endfor
  return a:qf
endfunction

"エントリ内からパターンを探して返す
function! s:GetPatternInEntry(file, pattern, lnum)
  let file = expand(a:file)
  let pattern = a:pattern
  let lnum = a:lnum
  let tfmt = '%Y%m%d%H%M'
  if s:prevgepname != file
    "検索対象は半角なのでiconvしない
    silent! let s:tempfilebuf = readfile(file)
    let s:prevgepname = file
  endif
  let l:QFixHowm_Title = QFixHowmGetTitleSearchRegxp()
  let idx = lnum - 1
  for n in range(idx, 0, -1)
    let idx = n
    if n >= len(s:tempfilebuf)
      continue
    endif
    if n == 0 || s:tempfilebuf[n] =~ l:QFixHowm_Title
      break
    endif
  endfor
  let idx = idx + 1
  let end = len(s:tempfilebuf) - 1
  let text = ''
  if end - idx >= 0
    for n in range(idx, end)
      if s:tempfilebuf[n] =~ pattern
        let text = matchstr(s:tempfilebuf[n], pattern)
        break
      endif
      if s:tempfilebuf[n] =~ l:QFixHowm_Title || n == end
        let idx = -1
      endif
    endfor
  endif
  if text == ''
    return strftime(tfmt, getftime(file))
  else
    let text = matchstr(text, pattern)
    let text = substitute(text, '[^0-9]', '', 'g')
    let text = matchstr(text, '\d\{12}')
    return text
  endif
endfunction

function! QFixHowmListDiary()
  if QFixHowmInit()
    return
  endif
  let QFixHowm_SearchDiaryFile = g:QFixHowm_SearchDiaryFile
  if g:QFixHowm_HowmMode == 0 && g:QFixHowm_UserFileType == 'vimwiki'
    let g:QFixHowm_SearchDiaryFile = '**/'.VimwikiGet('diary_rel_path').'*.'.g:QFixHowm_UserFileExt
  endif

  let tpattern = g:QFixHowm_Title
  if g:QFixHowm_SearchDiaryMode
    let g:QFixHowm_SearchDiaryFile = substitute(g:QFixHowm_SearchDiaryFile, '^\*\*/', '', '')
    let g:QFixHowm_SearchDiaryFile = substitute(g:QFixHowm_SearchDiaryFile, '\.', '\.' , 'g')
    let g:QFixHowm_SearchDiaryFile = substitute(g:QFixHowm_SearchDiaryFile, '\*', '.*' , 'g')
    let g:QFixHowm_SearchDiaryFile = substitute(g:QFixHowm_SearchDiaryFile, '?', '.' , 'g')
    call QFixHowmListAllTitleAlt('Diary')
  else
    let QFixHowm_SearchHowmFile = g:QFixHowm_SearchHowmFile
    let g:QFixHowm_SearchHowmFile = g:QFixHowm_SearchDiaryFile
    call QFixHowmListAllTitle_(tpattern, 0)
    let g:QFixHowm_SearchHowmFile = QFixHowm_SearchHowmFile
  endif
    let g:QFixHowm_SearchDiaryFile = QFixHowm_SearchDiaryFile
endfunction

"QFixHowm_RecentMode > 0 の更新時間ソート
function! QFixHowmCompareTime(v1, v2)
  if a:v1.time == a:v2.time
    if bufname(a:v1.bufnr) == bufname(a:v2.bufnr)
      return (a:v1.lnum > a:v2.lnum?1:-1)
    else
      return (bufname(a:v1.bufnr) < bufname(a:v2.bufnr)?1:-1)
    endif
  endif
  return (a:v1.time < a:v2.time?1:-1)
endfunction

" 過去days日以内のエントリの検索
" 実行時にカウントが指定されていたら、カウント日以内のエントリを検索する。
command! -count -nargs=* QFixHowmListRecent  call QFixHowmListRecent(g:QFixHowm_Title)
command! -count -nargs=* QFixHowmListRecentC call QFixHowmListRecent(g:QFixHowm_Title, 'Last Create')
function! QFixHowmListRecent(pattern, ...)
  if QFixHowmInit()
    return
  endif
  let addflag = 0
  if count
    let g:QFixHowm_RecentDays = count
  endif
  let days = g:QFixHowm_RecentDays
  let pattern = a:pattern
  let s:UseTitleFilter = 1
  let mtime_mode = 0
  if g:QFixHowm_RecentMode == 0
    let mtime_mode = 1
  endif
  if g:QFixHowm_HowmMode == 0
    let mtime_mode = 1
  endif
  if a:0
    let mtime_mode = !mtime_mode
  endif
  if mtime_mode || g:mygrepprg == 'findstr'
    let l:QFixHowm_HowmTimeStampSort = g:QFixHowm_HowmTimeStampSort
    if g:QFixHowm_RecentMode != 0 && a:0
      let g:QFixHowm_HowmTimeStampSort = 0
    endif
    call QFixHowmListAllTitle_(pattern, days, 1)
    if g:mygrepprg == 'findstr'
      let sq = QFixHowmSort('howmtime', days)
      "call QFixSetqflist(sq)
    endif
    let g:QFixHowm_HowmTimeStampSort = l:QFixHowm_HowmTimeStampSort
    return
  endif
  let pattern = '^'.a:pattern
  QFixCclose
  let prevPath = escape(getcwd(), ' ')
  let l:howm_dir = g:howm_dir
  if !exists('g:mygrepprg') || g:mygrepprg == 'internal' || g:mygrepprg == ''
    if g:QFixHowm_RecentMode == 3 || g:QFixHowm_RecentMode == 4
      let searchWord = '^'.s:sch_dateTime.' (\('.strftime('%Y%m%d')
      for day in range(1,l:days-1,1)
        let searchWord = searchWord . '\|' . strftime('%Y%m%d', localtime()-(day*24*60*60))
      endfor
      let searchWord = searchWord . '\)'
    else
      let searchWord = '^\[\('.strftime(s:hts_date)
      for day in range(1,l:days-1,1)
        let searchWord = searchWord . '\|' . strftime(s:hts_date, localtime()-(day*24*60*60))
      endfor
      let searchWord = searchWord . '\) \('.s:sch_time.'\)*\]\('.s:sch_notExt.'\|$\)'
    endif
    let g:MyGrep_UseVimgrep = 1
  else
    if g:QFixHowm_RecentMode == 3 || g:QFixHowm_RecentMode == 4
      let searchWord = '^\['.s:sch_ExtGrep.'\] \(('.strftime('%Y%m%d')
      for day in range(1,l:days-1,1)
        let searchWord = searchWord . '|'.strftime('%Y%m%d', localtime()-(day*24*60*60))
      endfor
      let searchWord = searchWord.')'
    else
      let searchWord = '^\[('.strftime(s:hts_date)
      for day in range(1,l:days-1,1)
        let searchWord = searchWord . '|'.strftime(s:hts_date, localtime()-(day*24*60*60))
      endfor
      let searchWord = searchWord.') ([0-9]{2}:[0-9]{2})?]('.s:sch_notExt.'|$)'
    endif
  endif
  redraw|echo 'QFixHowm : Searching...'
  let addflag = MultiHowmDirGrep(searchWord, g:howm_dir, g:QFixHowm_SearchHowmFile, g:howm_fileencoding, addflag)
  call MyGrep(searchWord, g:howm_dir, g:QFixHowm_SearchHowmFile, g:howm_fileencoding, addflag)

  let sq = QFixHowmSort('ttime', days)
  let idx = 0
  let s:prevfname = ''
  let h = g:QFix_Height
  for d in sq
    let tpat = escape(l:pattern, g:QFixHowm_EscapeTitle)
    let ret = s:QFixHowmListRecentReplaceTitle(bufname(d.bufnr), tpat, d.lnum)
    if ret[0] != ''
      let d.text = ret[0]
      let d.lnum = ret[1]
    endif
    let idx = idx + 1
  endfor
  let g:QFix_Height = h
  call QFixHowmTitleFilter(sq)
  call QFixSetqflist(sq)
  if g:QFix_SearchPathEnable && g:QFix_SearchPath != ''
  endif
  let g:howm_dir = l:howm_dir
  if empty(sq)
    QFixCclose
    redraw | echo 'QFixHowm : Not found!'
  else
    QFixCopen
    redraw|echo ''
  endif
  if g:QFix_PreviewUpdatetime == 0
    call QFixPreview()
  endif
  return
endfunction

"サマリー表示用のタイトル行を探す。
let s:prevfname = ''
function! s:QFixHowmListRecentReplaceTitle(file, pattern, lnum)
  let text = ''
  let lnum = a:lnum
  let retval = [text, lnum]
  let [text, lnum, elnum] = QFixMRUGet('title', a:file, lnum)
  return [text, lnum]
endfunction

"カレントバッファのエントリを更新時間順にソート
function! QFixHowmSortEntry(mode)
  let elist = s:QFixHowmGetEntryList()
  if elist == []
    return
  endif
  "ソートする
  if a:mode == 'normal'
    let elist = sort(elist, "<SID>QFixHowmSortEntryMtime")
  else
    let elist = sort(elist, "<SID>QFixHowmSortEntryMtimeR")
  endif
  "書き換え
  silent! %delete _
  for d in elist
    silent! put=d.text
  endfor
  call cursor(1, 1)
  silent! delete _
  let g:QFixHowm_WriteUpdateTime = 0
  write
  unlet! elist
endfunction

"カレントバッファのエントリリストを得る
function! s:QFixHowmGetEntryList()
  let save_cursor = getpos('.')
  let l:QFixHowm_Title = QFixHowmGetTitleSearchRegxp()
  let elist = []
  call cursor('1', '1')
  let fline = search(l:QFixHowm_Title, 'ncW')
  if fline > 0
    call cursor(fline, '1')
    while 1
      let endline = search(l:QFixHowm_Title, 'nW')-1
      if endline <= 0
        let endline = line('$')
      endif
      let pattern = '^'.s:sch_dateTime. '\('.s:sch_notExt.'\|[\n\r]\)'
      let timeline = search(pattern, 'nW')
      if timeline == 0 || timeline > endline
        "ここでQFixHowm_RecentModeで場合分けして更新時間をゲット
        let tline = 0
      else
        let tline = getline(timeline)
        if g:QFixHowm_RecentMode == 0 || g:QFixHowm_RecentMode == 1 || g:QFixHowm_RecentMode == 2
          let pattern = '^'.s:sch_dateTime
        elseif g:QFixHowm_RecentMode == 3 || g:QFixHowm_RecentMode == 4
          let pattern = s:Recentmode_Date
        endif
        let tline = matchstr(tline, pattern)
        let tline = substitute(tline, '[^0-9]', '', 'g')
        if tline == ''
          let tline = 0
        endif
      endif
      let text = ''
      for i in range(fline, endline)
        let text = text . getline(i) . "\<NL>"
      endfor
      let ttext = getline(fline)
      let mydict = {'fline':fline, 'eline':endline, 'mtime':tline, 'text':text, 'title':ttext}
      call add(elist, mydict)
      let fline = endline+1
      if search(l:QFixHowm_Title, 'W') == 0
        break
      endif
    endwhile
    call setpos('.', save_cursor)
    return elist
  endif
  call setpos('.', save_cursor)
  return []
endfunction

function! s:QFixHowmSortEntryMtime(v1, v2)
  return (a:v1.mtime <= a:v2.mtime?1:-1)
endfunction

function! s:QFixHowmSortEntryMtimeR(v1, v2)
  return (a:v1.mtime >= a:v2.mtime?1:-1)
endfunction

""""""""""""""""""""""""""""""
"ファイルリスト
""""""""""""""""""""""""""""""
"ファイルリスト最大表示数
if !exists('g:QFixHowm_FileListMax')
  let g:QFixHowm_FileListMax = 0
endif
"ファイルリストのglobパラメータ
if !exists('g:QFixHowm_FileList')
  let g:QFixHowm_FileList = '**/*'
endif

"ファイルリストを作成して登録
command! -count -nargs=* QFixHowmFileList if count > 0|let g:QFixHowm_FileListMax = count|endif|call QFixHowmFileList(g:howm_dir, g:QFixHowm_FileList)
function! QFixHowmFileList(path, file, ...)
  let path = expand(a:path)
  if path == ''
    let path = expand("%:p:h")
  endif
  if !isdirectory(path)
    echoe '"' . a:path.'" does not exist!'
    return
  endif
  redraw|echo 'QFixHowm : Searching...'
  let list = QFixHowmGetFileList(path, a:file)
  let cnt = g:QFixHowm_FileListMax
  if count
    let cnt = count
  endif
  if cnt
    silent! call remove(list, cnt, -1)
  endif
  "サマリーを付加
  call QFixHowmFLaddtitle(path, list)
  if a:0
    return list
  endif
  let glist = []
  for d in list
    let from = d['filename']
    call add(glist, printf("%s|%d|%s", from, 1, d['text']))
  endfor
  if len(glist) == 0
    redraw | echo 'QFixHowm : Not found!'
    return
  endif
  redraw | echo ''
  call SetHowmFiles(glist)
endfunction

"quickfixのリストにタイトルを付加
function! QFixHowmFLaddtitle(path, list)
  let prevPath = escape(getcwd(), ' ')
  let h = g:QFix_Height
  silent! exec 'split '
  silent! exec 'silent! edit '.s:howmtempfile
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal nobuflisted
  let prevfname = ''
  for d in a:list
    let file = d.filename
    if !filereadable(file)
      continue
    endif
    if prevfname != file
      silent! %delete _
      let tmpfile = escape(file, ' #%')
      silent! exec '0read '.tmpfile
      silent! $delete _
    endif
    let prevfname = file
    call cursor(d.lnum, 1)
    for i in range(1, line('$'))
      let str = getline(i)
      if str != ''
        let d.text = str
        let d.lnum = i
        break
      endif
    endfor
  endfor
  silent! exec 'silent! edit '.s:howmtempfile
  setlocal buftype=nofile
  silent! bd!
  let g:QFix_Height = h
endfunction

"ファイルリストの作成
function! QFixHowmGetFileList(path, file)
  let prevPath = escape(getcwd(), ' ')
  exec 'lchdir ' . escape(a:path, ' ')
  let files = split(glob(a:file), '\n')
  let list = []
  let lnum = 1
  let text = ''
  if g:MyGrep_ExcludeReg == ''
    let g:MyGrep_ExcludeReg = '^$'
  endif
  for n in files
    let n = a:path . '/'. n
    let n = fnamemodify(n, ':p')
    if !isdirectory(n)
      if n =~ g:MyGrep_ExcludeReg
        continue
      endif
      let usefile = {'filename':n, 'lnum':lnum, 'text':text}
      call insert(list, usefile)
    endif
  endfor
  silent! exec 'lchdir ' . prevPath
  return list
endfunction

""""""""""""""""""""""""""""""
"autolink keyword
""""""""""""""""""""""""""""""
"howmのキーワードファイル
if !exists('g:QFixHowm_keywordfile')
  if exists('g:howm_keywordfile')
    let g:QFixHowm_keywordfile = g:howm_keywordfile
  else
    let g:QFixHowm_keywordfile = '~/.howm-keys'
  endif
endif
"オートリンクのタグジャンプを有効にする。
if !exists('g:QFixHowm_UseAutoLinkTags')
  let g:QFixHowm_UseAutoLinkTags = 0
endif
"オートリンク用tagsを作成するディレクトリ
if !exists('g:QFixHowm_TagsDir')
  let g:QFixHowm_TagsDir = g:howm_dir
endif
let g:QFixHowm_KeywordList = []

"QFixHowm_keywordfileからオートリンクを読み込む
function! QFixHowmLoadKeyword()
  let kfile = expand(g:QFixHowm_keywordfile)
  if !filereadable(kfile)
    return
  endif
  let g:QFixHowm_keyword = ''
  let g:QFixHowm_KeywordList = []
  let g:howm_keyword = ''
  for keyword in readfile(kfile)
    if keyword =~ '^\s*$'
      continue
    endif
    call add(g:QFixHowm_KeywordList, keyword)
    let keyword = substitute(keyword, '\s*$', '', '')
    let keyword = substitute(keyword, '^\s*', '', '')
    if g:QFixHowm_clink_type == 'word'
      let keyword = escape(keyword, '<>\')
      let g:QFixHowm_keyword = g:QFixHowm_keyword.'\<'.keyword.'\>\|'
    else
      let g:QFixHowm_keyword = g:QFixHowm_keyword.''.keyword.'\|'
    endif
    let g:howm_keyword = g:howm_keyword.''.keyword.'\|'
  endfor
  let g:QFixHowm_keyword = substitute(g:QFixHowm_keyword, '\\|\\|', '\\|', '')
  let g:QFixHowm_keyword = substitute(g:QFixHowm_keyword, '\\|\s*$', '', '')
  let g:QFixHowm_keyword = substitute(g:QFixHowm_keyword, '^\\|', '', '')
  let g:howm_keyword = substitute(g:howm_keyword, '\\|\s*$', '', '')
endfunction

"現在のファイルからQFixHowm_keywordfileへオートリンクを保存
let s:KeywordDic = []
function! QFixHowmAddKeyword()
  let save_cursor = getpos('.')
  let kfile = expand(g:QFixHowm_keywordfile)
  if filereadable(kfile)
    let s:KeywordDic = readfile(kfile)
  else
    let s:KeywordDic = []
  endif
  let kdic = deepcopy(s:KeywordDic)
  let idx = 0
  for str in s:KeywordDic
    if str =~ '^\s*$'
      call remove(s:KeywordDic, idx)
      continue
    endif
    let idx += 1
  endfor
  call cursor('1','1')
  let [lnum, stridx] = searchpos(g:howm_clink_pattern, 'cW')
  let cmode = 1
  while 1
    if stridx == 0 && lnum == 0
      break
    endif
    call cursor(lnum, stridx)
    let text = getline('.')
    let keyword = strpart(text, stridx-1)
    let keyword = substitute(keyword, g:howm_clink_pattern.'\s*', '', '')
    let keyword = substitute(keyword, '\s*$', '', '')
    if count(s:KeywordDic, keyword) == 0 && keyword !~ '^\s*$'
      call add(s:KeywordDic, keyword)
    endif
    let etext = g:howm_clink_pattern.'\s*'.'\V'.escape(keyword, '/')
    if getline('.') =~ etext
      call QFixHowmSaveAutolinkTag(keyword, expand('%:p'), lnum, cmode)
      let cmode = 0
    endif
    let [lnum, stridx] = searchpos(g:howm_clink_pattern, 'W')
  endwhile
  for lnum in range(1, line('$'))
    let text = getline(lnum)
    while 1
      let stridx = match(text, '\[\[')
      let pairpos = matchend(text, ']]')
      if stridx == -1 || pairpos == -1
        break
      endif
      let keyword = strpart(text, stridx+2, pairpos-stridx-strlen('[[]]'))
      let keyword = substitute(keyword, '^\s*', '', '')
      let keyword = substitute(keyword, '\s*$', '', '')
      if count(s:KeywordDic, keyword) == 0 && keyword !~ '^\s*$'
        call add(s:KeywordDic, keyword)
      endif
      call QFixHowmSaveAutolinkTag(keyword, expand('%:p'), lnum, cmode)
      let cmode = 0
      let text = strpart(text, pairpos)
    endwhile
  endfor
  call sort(s:KeywordDic)
  call reverse(s:KeywordDic)
  if s:KeywordDic != kdic
    call writefile(s:KeywordDic, kfile)
  endif
  call QFixHowmLoadKeyword()
  call QFixHowmHighlight()
  call setpos('.', save_cursor)
endfunction

"QFixHowm_keywordfileを再作成
function! QFixHowmRebuildKeyword()
  QFixCclose
  let tfile = expand(g:QFixHowm_TagsDir) . '/tags'
  silent! call delete(tfile)
  let l:howm_dir = g:howm_dir
  let prevPath = escape(getcwd(), ' ')
  silent! cexpr ''
  let s:KeywordDic = []
  echo "QFixHowm : Rebuilding..."
  let file = g:QFixHowm_Menufile
  if g:QFixHowm_MenuDir == ''
    silent exec 'lchdir ' . escape(l:howm_dir, ' ')
  else
    silent exec 'lchdir ' . escape(g:QFixHowm_MenuDir, ' ')
  endif
  silent! exec 'vimgrepadd /\('.g:howm_clink_pattern.'\|'.'\[\[[^\]]\+\]\]'.'\)/j '. file
  silent exec 'lchdir ' . escape(l:howm_dir, ' ')
  if !exists('g:mygrepprg') || g:mygrepprg == 'internal' || g:mygrepprg == '' || g:mygrepprg == 'findstr'
    silent! exec 'vimgrepadd /\('.g:howm_clink_pattern.'\|'.'\[\[[^\]]\+\]\]'.'\)/j **/*.'.g:QFixHowm_FileExt
  else
    let searchWord = '('.g:howm_clink_pattern.'|'.'\[\[[^]]+\]\]'.')'
    call MyGrep(searchWord, '', '**/*.'.g:QFixHowm_FileExt , g:howm_fileencoding, 1)
  endif
  let prevbufname = ''
  let prevbufnr = -1
  let save_qflist = QFixGetqflist()
  for d in save_qflist
    let file = bufname(d.bufnr)
    if file == prevbufname
      continue
    endif
    let fbuf = readfile(file)
    let lnum = 0
    for text in fbuf
      let lnum = lnum + 1
      if text !~ g:howm_clink_pattern
        continue
      endif
      let keyword = substitute(text, '.*'.g:howm_clink_pattern.'\s*', '', '')
      let keyword = substitute(keyword, '\s*$', '', '')
      if count(s:KeywordDic, keyword) == 0 && keyword !~ '^\s*$'
        call add(s:KeywordDic, keyword)
      endif
      let etext = g:howm_clink_pattern.'\s*'.'\V'.escape(keyword, '/')
      if text =~ etext
        let cmode = 0
        if prevbufnr != d.bufnr
          let cmode = 1
        endif
        let prevbufnr = d.bufnr
        call QFixHowmSaveAutolinkTag(keyword, fnamemodify(file, ":p"), lnum, cmode)
      endif
    endfor
    "wiki style link
    let lnum = 0
    for text in fbuf
      let lnum = lnum + 1
      if text !~ '\[\['
        continue
      endif
      while 1
        let stridx = match(text, '\[\[')
        let pairpos = matchend(text, ']]')
        if stridx == -1 || pairpos == -1
          break
        endif
        let keyword = strpart(text, stridx+2, pairpos-stridx-strlen('[[]]'))
        let keyword = substitute(keyword, '^\s*', '', '')
        let keyword = substitute(keyword, '\s*$', '', '')
        let text    = strpart(text, pairpos)
        if count(s:KeywordDic, keyword) == 0 && keyword !~ '^\s*$'
          call add(s:KeywordDic, keyword)
          let cmode = 0
          if prevbufnr != d.bufnr
            let cmode = 1
          endif
          let prevbufnr = d.bufnr
          call QFixHowmSaveAutolinkTag(keyword, fnamemodify(file, ":p"), lnum, cmode)
        endif
      endwhile
    endfor
    let prevbufname = bufname(d.bufnr)
  endfor
  call sort(s:KeywordDic)
  call reverse(s:KeywordDic)
  call writefile(s:KeywordDic, expand(g:QFixHowm_keywordfile))
  call QFixHowmLoadKeyword()
  call QFixHowmHighlight()
  silent exec 'lchdir ' . prevPath
  QFixCopen
  redraw | echo "QFixHowm : Completed."
  return
endfunction

"オートリンク定義へタグジャンプする
function! QFixHowmOpenClink()
  if g:QFixHowm_UseAutoLinkTags == 0
    return 0
  endif
  "TODO:ここにタグジャンプを実装する
  return 0
  exec 'normal! <C-]>'
  return 1
endfunction

"オートリンクtagジャンプファイルを作成する
"tags互換
function! QFixHowmSaveAutolinkTag(keyword, file, lnum, mode)
  if g:QFixHowm_UseAutoLinkTags == 0 || a:keyword =~ '^\s*$'
    return
  endif
  let tdir = expand(g:QFixHowm_TagsDir)
  let tdir = substitute(tdir, '\\', '/', 'g')
  let tdir = substitute(tdir, '/\+', '/', 'g')
  let tfile = tdir . '/tags'

  let file = fnamemodify(a:file, ':p')
  let file = substitute(file, '\\', '/', 'g')
  let file = substitute(file, '/\+', '/', 'g')

  let relfname = './' . substitute(file, tdir, '', '')
  let relfname = file
  if filereadable(tfile)
    let tdic = readfile(tfile)
  else
    let tdic = []
  endif
  let otdic = deepcopy(tdic)
  if a:mode
    "fileと同じファイル名のリストを全削除
    let idx = 0
    for d in tdic
      if d =~ '\V'.relfname
        silent! call remove(tdic, idx)
      else
        let idx = idx+1
      endif
    endfor
  endif
  let keyword = a:keyword
  "keyword, relfname, lnumを登録
  let tline = keyword . "\t" . relfname . "\t" . a:lnum
  call add(tdic, tline)

  let skeyword = matchstr(keyword, '[^ ]*')
  if skeyword != keyword
    let tline = skeyword . "\t" . relfname . "\t" . a:lnum
    call add(tdic, tline)
  endif
  let tdic = sort(tdic)
  if otdic != tdic
    call writefile(tdic, tfile)
  endif
endfunction

""""""""""""""""""""""""""""""
"折りたたみ
""""""""""""""""""""""""""""""
"折りたたみを有効にする。
if !exists('g:QFixHowm_Folding')
  let g:QFixHowm_Folding = 1
endif
"折りたたみに ワイルドカードチャプターを使用する
if !exists('g:QFixHowm_WildCardChapter')
  let g:QFixHowm_WildCardChapter = 0
endif
"階層付きテキストもワイルドカードチャプター変換の対象にする
if !exists('g:QFixHowm_WildCardChapterMode')
  let g:QFixHowm_WildCardChapterMode = 1
endif
"チャプターのタイトル行を折りたたみに含める/含めない
if !exists('g:QFixHowm_FoldingChapterTitle')
  let g:QFixHowm_FoldingChapterTitle = 0
endif
"折りたたみのパターン
if !exists('g:QFixHowm_FoldingPattern')
  let g:QFixHowm_FoldingPattern = '^[=.*]'
endif
"折りたたみのレベル設定
if !exists('g:QFixHowm_FoldingMode')
  let g:QFixHowm_FoldingMode = 0
endif

"アウトライン呼び出し
silent! function QFixHowmOutline()
  silent exec "normal! zi"
endfunction

"フォールディングレベル計算
let s:schepat = '^\s*'.s:sch_dateT.s:sch_Ext
silent! function QFixHowmFoldingLevel(lnum)
  let s:titlepat = '^'.escape(g:QFixHowm_Title, g:QFixHowm_EscapeTitle).'\([^'.g:QFixHowm_Title.']\|$\)'
  let text = getline(a:lnum)
  if text =~ s:titlepat || text =~ s:schepat
    if g:QFixHowm_Folding == 1
      return '>1'
    endif
    return '0'
  endif
  "カードチャプターに応じて折りたたみレベルを設定する
  let wild = '\(\(\d\+\|\*\)\.\)\+\(\d\+\|\*\)\?'
  let str = matchstr(text, '^\s*'.wild.'\s*')
  let str = substitute(str, '\d\+', '*', 'g')
  let level = strlen(substitute(str, '[^*]', '' , 'g'))
  if level == 0 && g:QFixHowm_FoldingPattern != ""
    let str = matchstr(text, g:QFixHowm_FoldingPattern.'\+')
    let str = substitute(str, '[^'.str[0].'].*$', '', 'g')
    let level = strlen(str)
  endif
  if g:QFixHowm_FoldingMode == 0
    if level
      if g:QFixHowm_FoldingChapterTitle == 0
        return '>1'
      endif
      return '0'
    endif
    return '1'
  elseif g:QFixHowm_FoldingMode == 1
    if level
      return '>'.level
    endif
    return 'a'
  endif
  return '1'
endfunction

"折りたたみ範囲をコピー/削除
function! QFixHowmFoldText(cmd)
  let saved_fen = &foldenable
  let save_cursor = getpos('.')
  setlocal foldenable
  let c = count > 1 ? count : 1
  for n in range(1, c)
    silent! exec 'normal! zczj'
  endfor
  call setpos('.', save_cursor)
  if foldlevel(line('.'))
    exec 'normal! ' .c. a:cmd
  else
    echohl ErrorMsg
    echo 'No fold found!'
    echohl None
  endif
  let &foldenable = saved_fen
  if a:cmd == 'yy'
    call setpos('.', save_cursor)
  endif
endfunction

" *. 形式のワイルドカードチャプターを数字に変換
silent! function CnvWildcardChapter(...) range
  let firstline = a:firstline
  let lastline = a:lastline
  if a:0 == 0
    let firstline = 1
    let lastline = line('$')
  endif
  let top = 0
  let wild = '\(\*\.\)\+\*\?\s*'
  if g:QFixHowm_WildCardChapterMode
    let wild = wild . '\|^\.\+\s*'
  endif
  let nwild = '\(\d\+\.\)\+\(\d\+\)\?'
  let chap = [top, 0, 0, 0, 0, 0, 0, 0]
  let plevel = 1
  let save_cursor = getpos('.')
  for l in range(firstline, lastline)
    let str = matchstr(getline(l), '^\s*'.nwild.'\s*')
    if str != ''
      for c in range(8)
        let ch = matchstr(str,'\d\+', 0 ,c+1)
        let chap[c] = 0
        if ch != ''
          let chap[c] = ch
        endif
      endfor
      continue
    endif
    let str = matchstr(getline(l), '^\s*'.wild)
    let len = strlen(str)
    if str[0] == '.'
      let str = substitute(str, '\.', '*.', 'g')
      if strlen(substitute(str, '\s*$', '', '')) > 2
        let str = substitute(str, '\.\(\s*\)$', '\1', 'g')
      endif
    endif
    let level = strlen(substitute(str, '[^*]', '' , 'g'))
    if level == 0
      continue
    endif
    let chap[level-1] = chap[level-1] + 1
    if level < plevel
      for n in range(level, 8-1)
        let chap[n] = 0
      endfor
    endif
    let plevel = level
    for n in range(level)
      let str = substitute(str, '\*', chap[n], '')
    endfor
    let nstr = str . strpart(getline(l), len)
    let sline = line('.')
    call setline(l, [nstr])
  endfor
  call setpos('.', save_cursor)
endfunction

"=============================================================================
" for howmfiles.vim
"=============================================================================
" ショートカットキー実行
function! QFixHowmCmd(cmd)
  if a:cmd =~ '^[sg]$' && g:QFixHowm_DefaultSearchWord == 1
    let g:QFixHowm_DefaultSearchWord = -1
  endif
  let cmd = s:QFixHowm_Key.a:cmd
  echo 'QFixHowm : exec '.cmd
  call feedkeys(cmd, 't')
endfunction

"=============================================================================
" 自動整形
"=============================================================================
"更新時間を管理する
if !exists('g:QFixHowm_RecentMode')
  let g:QFixHowm_RecentMode = 0
endif
"更新時間埋め込み
if !exists('g:QFixHowm_SaveTime')
  let g:QFixHowm_SaveTime = 0
endif
"howmファイルの自動整形を使用する
if !exists('g:QFixHowm_Autoformat')
  let g:QFixHowm_Autoformat = 1
endif
"行頭にQFixHowm_Titleがある行は全てタイトルとみなして整形する
if !exists('g:QFixHowm_Autoformat_TitleMode')
  let g:QFixHowm_Autoformat_TitleMode = 1
endif
"オートタイトル文字数
if !exists('g:QFixHowm_Replace_Title_Len')
  let g:QFixHowm_Replace_Title_Len = 64
endif
"オートタイトル正規表現
if !exists('g:QFixHowm_Replace_Title_Pattern')
  let g:QFixHowm_Replace_Title_Pattern = '^'.escape(g:QFixHowm_Title, g:QFixHowm_EscapeTitle).'\s*\(\[[^\]]*\]\s*\)*\s*$'
endif
"howmファイルのBOM削除
if !exists('g:QFixHowm_NoBOM')
  let g:QFixHowm_NoBOM = 0
endif

"書き込み時の日付更新用フラグ
let g:QFixHowm_WriteUpdateTime = 1

"Howmファイルの書き込み時に更新時間を書き込む。
"TODO:編集位置を自分で全て探して自動で変更する。
function! QFixHowmInsertLastModified(...)
  if !IsQFixHowmFile('%')
    return
  endif
  let saved_reg = @/
  if g:QFixHowm_RecentMode == 0 && g:QFixHowm_SaveTime == -1
    let g:QFixHowm_WriteUpdateTime = 0
  endif
  call s:Autoformat()
  let save_cursor = getpos('.')
  let l:QFixHowm_Title = escape(g:QFixHowm_Title, g:QFixHowm_EscapeTitle)
  let l:QFixHowm_Title = l:QFixHowm_Title.'\(\s\|$\)'
  if g:QFixHowm_WriteUpdateTime > 0 || a:0
    "タイトルのみのエントリに自動で更新時刻を付加する。
    call cursor('1', '1')
    let fline = search('^'.l:QFixHowm_Title, 'ncW')
    if fline > 0
      call cursor(fline, '1')
      while 1
        let endline = search('^'.l:QFixHowm_Title, 'nW')
        if endline == 0
          let endline = line('$')
        endif
        let pattern = '^'.s:sch_dateTime.'\('.s:sch_notExt.'\|$\)'
        if g:QFixHowm_RecentMode == 3 || g:QFixHowm_RecentMode == 4
          " let pattern = '^'.s:sch_dateTime.' '. s:Recentmode_Date.'$'
        endif
        let timeline = search(pattern, 'nW')
        if timeline == 0 || timeline > endline
          silent! put='['.strftime(s:hts_dateTime).']'
        endif
        if search('^'.l:QFixHowm_Title, 'W') == 0
          break
        endif
      endwhile
    endif
    if g:QFixHowm_RecentMode > 0 || g:QFixHowm_SaveTime > 0 || a:0
      call setpos('.', save_cursor)
      call s:GetChanges(a:0)
      call setpos('.', save_cursor)
    endif
  endif
  let g:QFixHowm_WriteUpdateTime = 1
  "空白のタイトル行に適当な文字列設定。
  if g:QFixHowm_Replace_Title_Len > 0
    call cursor('1', '1')
    while 1
      let pattern = g:QFixHowm_Replace_Title_Pattern
      if search(pattern, 'cW') == 0
        break
      endif
      let title = substitute(getline('.'), '\s*$', '', '')
      let tline = line('.')
      while 1
        call cursor(line('.')+1, '1')
        let str = getline('.')
        if str =~ '^' . l:QFixHowm_Title
          let str = ''
          break
        endif
        if str !~ '^\s*'.s:sch_dateT && str !~ '^\s*$'
          break
        endif
        let str = ''
        if line('.') == line('$')
          break
        endif
      endwhile
      if str != ''
        call cursor(tline, '1')
        let len = strlen(str)
        let str = substitute(str, '\%>'.g:QFixHowm_Replace_Title_Len.'v.*','','')
        "let str = matchstr(str, '.\{'.g:QFixHowm_Replace_Title_Len/2.'}')
        if strlen(str) != len
          let str = str . '...'
        endif
        let pstr = getline('.')
        let rstr = title. ' '.str
        if pstr !~ escape(rstr, '[].*~\#')
          let sline = line('.')
          call setline(sline, [rstr])
        endif
      endif
      call cursor(tline+1, '1')
    endwhile
    call setpos('.', save_cursor)
  endif
  let @/ = saved_reg
  call setpos('.', save_cursor)
  "エントリ間の連続空白行を消去
  if g:QFixHowm_Autoformat > 1
    call cursor('1', '1')
    let n = search('^=', 'ncW')+1
    if n > 1
      silent! exec n.',$s/^=/\r=/'
      silent! exec '%s/\_s*[\n\r]=/\r\r=/'
    endif
  endif
  call setpos('.', save_cursor)
  unlet saved_reg
  unlet save_cursor
  return ''
endfunction

"howmファイルの自動整形
function! s:Autoformat()
  if g:QFixHowm_Autoformat == 0
    return
  endif
  if !IsQFixHowmFile('%')
    return
  endif
  if g:QFixHowm_NoBOM
    set nobomb
  endif
  let file = expand('%:t')
  if file =~ g:QFixHowm_Menufile
    return
  endif
  let save_cursor = getpos('.')
  let l:QFixHowm_Title = escape(g:QFixHowm_Title, g:QFixHowm_EscapeTitle)
  "ファイル先端からの連続空白行を消去
  for i in range(line('$'))
    if getline(1) =~ '^\s*$'
      exec '1delete _'
    else
      break
    endif
  endfor
  let save_cursor[1] = save_cursor[1]-i
  call setpos('.', save_cursor)

  "一行しかなくて、空白行なら終了。
  if line('$') == 1 && getline('.') =~ '^\s*$'
    exec '1delete _'
    silent! setlocal binary noendofline
    return
  endif
  "予定やTODOの行と空白しかないなら終了
  let spattern = '^'.s:sch_dateT.s:sch_Ext.'\|^\s*$'
  call cursor(1, 1)
  while 1
    if getline('.') !~ spattern
      break
    endif
    let endline = search('^.\+$', 'W')
    if endline == 0
      call s:deleteNullLines()
      call setpos('.', save_cursor)
      return
    endif
  endwhile
  let pattern = g:QFixHowm_MergeEntrySeparator
  let pattern = '^\(' . l:QFixHowm_Title . '\{2,}'. '\|' .g:QFixHowm_MergeEntrySeparator . '\)'

  "１行目は必ずタイトル行にする
  let l:eQFixHowm_Title = escape(g:QFixHowm_Title, '&/')
  call cursor(1, 1)
  if getline('.') !~ '^'.l:QFixHowm_Title && getline('.') !~ pattern && getline('.') !~ spattern
    exec "0put='".g:QFixHowm_Title . " '"
  else
    "一行目のみ、ちゃんとタイトル＋空白になってなかったら整形
    if getline('.') !~ '^'.l:QFixHowm_Title. ' ' && getline('.') !~ pattern
      let rstr = substitute(getline('.'), l:QFixHowm_Title.'\s*', l:eQFixHowm_Title.' ', '')
      let sline = line('.')
      call setline(sline, [rstr])
    endif
  endif
  call setpos('.', save_cursor)
  "全てのタイトル行を整形
  if g:QFixHowm_Autoformat_TitleMode == 1
    call cursor(1, 1)
    "カレントエントリのみなら
    while 1
      if getline('.') !~ '^'.l:QFixHowm_Title. ' ' && getline('.') !~ pattern
        let rstr = substitute(getline('.'), l:QFixHowm_Title.'\s*', l:eQFixHowm_Title.' ', '')
        let sline = line('.')
        call setline(sline, [rstr])
      endif
      "カレントエントリのみならここで終了
      if search('^'.l:QFixHowm_Title.'\S', 'W') == 0
        break
      endif
    endwhile
  endif

  "ファイル末尾を空白一行に
  call s:deleteNullLines()
  call setpos('.', save_cursor)
endfunction

function! s:deleteNullLines()
  "ファイル末尾を空白一行に
  call cursor(line('$'), 1)
  let endline = line('.')
  if getline('.') !~ '^$'
    exec "put=''"
  else
    let firstline = search('^.\+$', 'nbW')
    if firstline == 0
      return
    endif
    if firstline+2 <= endline
      exec firstline+2.','.endline.'delete _'
    endif
  endif
endfunction

"エントリ内の時間を更新
function! s:GetChanges(amode)
  let amode = 1
  let mode = 1
  let pattern = '^'.s:sch_dateTime.'\('.s:sch_notExt.'\|$\)'
  if g:QFixHowm_RecentMode == 0
    if g:QFixHowm_SaveTime == 0 || g:QFixHowm_SaveTime == 2 || g:QFixHowm_SaveTime == 4
      let amode = 0
    endif
    if g:QFixHowm_SaveTime == 3 || g:QFixHowm_SaveTime == 4
      let mode = 2
    endif
  endif
  if g:QFixHowm_RecentMode == 2 || g:QFixHowm_RecentMode == 4
    let amode = 0
  endif
  if a:amode
    let amode = 0
  endif
  if g:QFixHowm_RecentMode == 3 || g:QFixHowm_RecentMode == 4
    let mode = 2
  endif
  if mode == 2
    let pattern = '\(^'.s:sch_dateTime.'\)\s*\('.s:Recentmode_Date.'\)\?'
  endif
  let l:QFixHowm_Title = escape(g:QFixHowm_Title, g:QFixHowm_EscapeTitle)
  let l:QFixHowm_Title = '^'.l:QFixHowm_Title.'\(\s\|$\)'

  let save_cursor = getpos('.')
  call search(l:QFixHowm_Title, 'cbW')
  if amode
    call cursor(1, 1)
    if search(l:QFixHowm_Title, 'cW') == 0
      call cursor(line('$'), 1)
    endif
  endif
  while 1
    if line('.') == line('$')
      break
    endif
    let endline = search(l:QFixHowm_Title, 'nW')
    if endline == 0
      let endline = line('$')
    endif
    let timeline = search(pattern, 'W')
    if timeline && timeline < endline
      if mode == 1
        let rstr = substitute(getline('.'), pattern, '['.strftime(s:hts_dateTime).']\1', '')
        let sline = line('.')
        call setline(sline, [rstr])
      elseif mode == 2
        let rpattern = '\(^'.s:sch_dateTime.'\) \('.s:Recentmode_Date.'\)'
        let rstr = substitute(getline('.'), rpattern, '\1', '')
        let rpattern = '\(^'.s:sch_dateTime.'\)\('.s:sch_notExt.'\|$\)'
        let rstr = substitute(rstr,  rpattern, '\1 ('.strftime('%Y%m%d%H%M').')\2', '')
        let sline = line('.')
        call setline(sline, [rstr])
      endif
    endif
    if amode == 0
      break
    endif
    call cursor(endline, '1')
  endwhile
  call setpos('.', save_cursor)
endfunction

