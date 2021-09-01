lua << EOF
require('packer').use('junegunn/fzf.vim')
EOF

" Helpers {{{

" Add a default action to add entries to the quickfix
function! s:buildQuickfixList(lines) abort
  function! s:buildQuickfixItem(line) abort
    let l:matches = matchlist(a:line, '\v^(.{-})%(:(\d+))?%(:(\d+))?%(\s+(.+))?$')

    return {
      \ 'filename': l:matches[1],
      \ 'lnum': l:matches[2],
      \ 'col': l:matches[3],
      \ 'text': l:matches[4],
      \ }
  endfunction

  call setqflist(map(copy(a:lines), { k,v -> s:buildQuickfixItem(v) }))
  copen
  cc
endfunction

" }}}

" Config {{{

" The directory of fzf must also be in the runtimepath
if !filereadable('/usr/share/vim/vimfiles/plugin/fzf.vim')
  " Otherwise use the version in the dotfiles
  execute 'set runtimepath+='. $DOTFILES .'/fzf'
endif

let g:fzf_action = {
  \ 'ctrl-q': function('s:buildQuickfixList'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" To have fzf opening in a new window at the bottom of the screen
" let g:fzf_layout = {'down': '30%'}

" To have fzf opening ina floating window
let g:fzf_layout = {'window': {
  \ 'highlight': 'Comment',
  \ 'width': 0.99,
  \ 'height': 0.95,
  \ 'border': 'sharp',
\ }}

" Hide the status line when not using a floating window
if has('nvim') && type(get(get(g:, 'fzf_layout', {}), 'window', '')) != type({})
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \ | autocmd BufLeave <buffer> set laststatus=2 showmode ruler
endif

" }}}

" Mappings {{{

nmap <Leader>sf :GFiles<CR>
nmap <Leader>sF :Files<CR>
nmap <Leader>sb :Buffers<CR>
nmap <Leader>sc :Commits<CR>

nnoremap <silent> <Leader>rg :Rg \b<C-R>=expand('<cword>')<CR>\b<CR>

" }}}

" Commands {{{

" From fzf plugins

" To be able to pass options
command! -bang -nargs=* -complete=dir RRg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '. <q-args>, 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang H call fzf#vim#helptags(<bang>0)

" }}}

" vim: ts=2 sw=2 et fdm=marker
