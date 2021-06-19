if exists('*packager#init')
  call packager#add('itchyny/lightline.vim')
endif

" Configuration {{{

" Don't need it since it's already in the status line
set noshowmode
" Always show the tabline
set showtabline=2

let s:modified = '[+]'

" }}}

" Functions {{{

function! s:SID(...) abort " {{{
  if !exists('s:sid')
    let s:sid = matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
  endif

  if 0 < a:0
    return printf('<SNR>%s_%s', s:sid, a:1)
  else
    return s:sid
  endif
endfunction " }}}

function! s:percent() abort " {{{
  let l:percentage = (line('.') * 100) / line('$')

  return 50 < winwidth(0) ? printf('%3d%% ☰', l:percentage) : ''
endfunction " }}}

function! s:maxline() abort " {{{
  return 100 < winwidth(0) ? printf('%d ', line('$')) : ''
endfunction " }}}

function! s:fileformat() abort " {{{
  if exists('*WebDevIconsGetFileFormatSymbol')
    return winwidth(0) > 110 ? WebDevIconsGetFileFormatSymbol() : ''
  endif

  return winwidth(0) > 110 ? &fileformat : ''
endfunction " }}}

function! s:fileencoding() abort " {{{
  let l:encoding = !empty(&fileencoding) ? &fileencoding : &encoding

  return winwidth(0) > 70 ? l:encoding : ''
endfunction " }}}

function! s:filetype() abort " {{{
  let l:filetype = &filetype

  if !empty(l:filetype) && exists('*WebDevIconsGetFileTypeSymbol')
    let l:filetype .= ' '.WebDevIconsGetFileTypeSymbol()
  endif

  return winwidth(0) > 90 ? l:filetype : ''
endfunction " }}}

" a:1 string file-pattern, defaults to ':.'
" a:2 string filename, defaults to bufname()
function! s:filename(...) abort " {{{
  let l:filenamePattern = get(a:, 1, ':.')
  let l:filename = get(a:, 2, bufname())

  if empty(l:filename)
    return '[No Name]'
  elseif l:filename =~ '^fugitive://'
    return fnamemodify(FugitiveReal(l:filename), l:filenamePattern).' [Git]'
  else
    return fnamemodify(l:filename, l:filenamePattern)
  endif
endfunction " }}}

function! s:fileModified() abort " {{{
  return &modified ? s:modified : ''
endfunction " }}}

function! s:readonly() abort " {{{
  return &readonly ? '%#LightlineMiddle_red_0#' : ''
endfunction " }}}

function! s:gitbranch() abort " {{{
  if !exists('*FugitiveHead')
    return ''
  endif

  let l:branch = FugitiveHead(7)

  if !empty(l:branch)
    let l:branch = ' '.l:branch
  endif

  return l:branch
endfunction " }}}

function! s:githunks() abort " {{{
  if !exists('*GitGutterGetHunkSummary')
    return ''
  endif

  let [l:added, l:modified, l:deleted] = GitGutterGetHunkSummary()

  return printf('+%d ~%d -%d', l:added, l:modified, l:deleted)
endfunction " }}}

function! s:git() abort " {{{
  return trim(s:gitbranch().' '.s:githunks())
endfunction " }}}

function! s:tabs() abort " {{{
  " Don't print the tabs if there is only one
  if 1 == tabpagenr('$')
    return [[],[],[]]
  endif

  return lightline#tabs()
endfunction " }}}

function! s:tabWindows() abort " {{{
  let l:beforeCurrentWindowComponents = []
  " Only the index 1 from the result of a component_expand will be granted the
  " component_type highlight group
  let l:currentWindowComponent = ''
  let l:afterCurrentWindowComponents = []
  let l:currentWindowNumber = tabpagewinnr(tabpagenr())

  for windowNumber in range(1, tabpagewinnr(tabpagenr(), '$'))
    let l:component = printf('%%{%s(%d)}', s:SID('windowName'), windowNumber)

    " Reverse the order since it's on the right side
    if windowNumber > l:currentWindowNumber
      call add(l:beforeCurrentWindowComponents, l:component)
    elseif windowNumber == l:currentWindowNumber
      let l:currentWindowComponent = l:component
    else
      call add(l:afterCurrentWindowComponents, l:component)
    endif
  endfor

  return [l:beforeCurrentWindowComponents, [l:currentWindowComponent], l:afterCurrentWindowComponents]
endfunction " }}}

function! s:windowName(windowNumber) abort " {{{
  let l:bufferName = bufname(winbufnr(a:windowNumber))
  let l:filename = s:filename(':t', l:bufferName)

  if getwinvar(a:windowNumber, '&modified')
    let l:filename .= ' '.s:modified
  endif

  if exists('*WebDevIconsGetFileTypeSymbol')
    let l:filename .= ' '.WebDevIconsGetFileTypeSymbol(l:bufferName)
  endif

  return l:filename
endfunction " }}}

function! s:tabcount() abort " {{{
  return printf('tab %d/%d', tabpagenr(), tabpagenr('$'))
endfunction " }}}

function! s:tabModified(tabNumber) abort " {{{
  let l:windowNumber = tabpagewinnr(a:tabNumber)
  let l:isModified = gettabwinvar(a:tabNumber, l:windowNumber, '&modified')

  return l:isModified ? s:modified : ''
endfunction " }}}

function! s:tabIcon(tabNumber) abort " {{{
  if !exists('*WebDevIconsGetFileTypeSymbol')
    return ''
  endif

  return WebDevIconsGetFileTypeSymbol(bufname(winbufnr(tabpagewinnr(a:tabNumber))))
endfunction " }}}

" Errors handling {{{

function! s:checkForTrailingSpaces() abort " {{{
  if -1 < index(['md', 'markdown'], &filetype)
    " Disable for markdown format since two spaces at the end of a line is used
    " to force a carriage return
    return
  endif

  return 0 < search('\v\s+$', 'nw')
endfunction " }}}

function! s:checkForMixtIndentation() abort " {{{
  let l:useSpaceIndentations = search('\v^\s+', 'nw')
  let l:useTabIndentations = search('\v^\t+', 'nw')

  return l:useSpaceIndentations && l:useTabIndentations
endfunction " }}}

function! s:errors() abort " {{{
  let l:output = ''

  if &readonly || !&modifiable || 5000 < line('$')
    return l:output
  endif

  if s:checkForMixtIndentation()
    let l:output .= '[^\t]'
  endif

  if s:checkForTrailingSpaces()
    let l:output .= '[\s$]'
  endif

  return l:output
endfunction " }}}

function! s:ale() abort " {{{
  let l:firstError = ale#statusline#FirstProblem(bufnr('.'), 'error')

  if empty(l:firstError)
    return ''
  endif

  return printf('%d: %s', l:firstError.lnum, l:firstError.text)
endfunction " }}}

" }}}

" }}}

" Statusline {{{

let g:lightline = {
  \ 'colorscheme': 'base16_tomorrow_night',
  \ 'subseparator': {'left': '', 'right': ''},
  \ 'mode_map': {
    \ 'n': 'N',
    \ 'i': 'I',
    \ 'R': 'R',
    \ 'v': 'V',
    \ 'V': 'VL',
    \ '\<C-V>': 'VB',
    \ 'c': 'C',
    \ 's': 'S',
    \ 'S': 'SL',
    \ '\<C-S>': 'SB',
    \ 't': 'T',
  \ },
  \ 'active': {
    \ 'left': [
      \ ['mode', 'paste'],
      \ ['gitbranch'],
      \ ['truncate', 'filename', 'modified', 'readonly'],
    \ ],
    \ 'right': [
      \ ['errors', 'ale', 'lineinfo'],
      \ ['percent', 'maxline'],
      \ ['hexchar', 'fileformat', 'fileencoding', 'filetype'],
    \ ],
  \ },
  \ 'inactive': {
    \ 'left': [
      \ ['filename', 'readonly'],
    \ ],
    \ 'right': [],
  \ },
  \ 'tabline': {
    \ 'left': [
      \ ['tabs'],
    \ ],
    \ 'right': [
      \ ['tabWindows'],
    \ ],
  \ },
  \ 'tab': {
    \ 'active': ['tabnum', 'filename', 'modified', 'icon'],
    \ 'inactive': ['tabnum', 'filename', 'modified', 'icon'],
  \ },
  \ 'component_expand': {
    \ 'tabs': s:SID('tabs'),
    \ 'tabWindows': s:SID('tabWindows'),
    \ 'errors': s:SID('errors'),
    \ 'ale': s:SID('ale'),
  \ },
  \ 'component': {
    \ 'readonly': "%#LightlineMiddle_red_0#%{ &readonly ? '' : '' }",
    \ 'hexchar': '0x%B',
    \ 'truncate': '%<',
  \ },
  \ 'component_type': {
    \ 'tabs': 'tabsel',
    \ 'tabWindows': 'tabsel',
    \ 'close': 'raw',
    \ 'errors': 'error',
    \ 'ale': 'error',
  \ },
  \ 'component_visible_condition': {
      \ 'truncate': '0',
  \ },
  \ 'component_function': {
    \ 'percent': s:SID('percent'),
    \ 'maxline': s:SID('maxline'),
    \ 'fileformat': s:SID('fileformat'),
    \ 'fileencoding': s:SID('fileencoding'),
    \ 'filetype': s:SID('filetype'),
    \ 'filename': s:SID('filename'),
    \ 'modified': s:SID('fileModified'),
    \ 'gitbranch': s:SID('gitbranch'),
    \ 'tabcount': s:SID('tabcount'),
  \ },
  \ 'tab_component_function': {
    \ 'filename': 'lightline#tab#filename',
    \ 'modified': s:SID('tabModified'),
    \ 'readonly': 'lightline#tab#readonly',
    \ 'tabnum': 'lightline#tab#tabnum',
    \ 'icon': s:SID('tabIcon'),
  \ },
\ }

" }}}

" vim: ts=2 sw=2 fdm=marker
