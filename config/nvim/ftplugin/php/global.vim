" Global PHP filetype configurations

" Options {{{

" Defines a keyword accordingly to PHP labels definition:
" https://www.php.net/manual/en/language.variables.basics.php
setlocal iskeyword=a-z,A-Z,48-57,_,128-255

" foldlevelstart doesn't work for ftplugin
setlocal foldlevel=1 " To automaticaly open classes folds

setlocal cms=//%s

" }}}

" Mappings {{{

" Open the phpdoc for the word under the cursor
nnoremap <buffer> <silent> <C-k> :silent execute ':!xdg-open ' .
  \ 'https://php.net/en/' . expand('<cword>')<CR>

" }}}

" Commands {{{

command! -buffer Repl botright split term://php\ -a | normal! i

" }}}

" Switch visibility {{{

let s:visibilities = ['public', 'protected', 'private']
function! s:switchVisibility(forward) abort
  let l:visibility = expand('<cword>')
  let l:index = index(s:visibilities, l:visibility)

  if -1 == l:index
    return
  elseif 0 == l:index && !a:forward
    let l:index = 2
  elseif 2 == l:index && a:forward
    let l:index = 0
  elseif a:forward
    let l:index += 1
  else
    let l:index -= 1
  endif

  execute 'normal! ciw'.s:visibilities[l:index]
endfunction

nmap [v :call <SID>switchVisibility(v:false)<CR>
nmap ]v :call <SID>switchVisibility(v:true)<CR>

" }}}

" vim:ts=2:sw=2:et:fdm=marker
