if !exists('g:loaded_lightline')
  finish
endif

" Add error highlight {{{

function! s:addErrorHighlight() abort " {{{
  let l:normalPalette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette.normal
  let l:guifg = l:normalPalette.error[0][0]
  let l:ctermfg = l:normalPalette.error[0][2]

  for position in ['Left', 'Middle', 'Right']
    let l:positionPalette = l:normalPalette[tolower(position)]

    for groupIndex in range(len(l:positionPalette))
      let l:guibg = l:positionPalette[groupIndex][1]
      let l:ctermbg = l:positionPalette[groupIndex][3]

      exec printf(
        \ 'hi Lightline%s_%s_%s guifg=%s guibg=%s ctermfg=%s ctermbg=%s',
        \ position,
        \ 'red',
        \ groupIndex,
        \ l:guifg,
        \ l:guibg,
        \ l:ctermfg,
        \ l:ctermbg
      \ )
    endfor
  endfor
endfunction " }}}

call s:addErrorHighlight()

" }}}

" Auto commands {{{

function! s:refreshStatusLine() abort " {{{
  if get(b:, 'statusline_changedtick', 0) == b:changedtick
    " Do nothing if the buffer has not changed
    return
  endif

  call lightline#update()
  let b:statusline_changedtick = b:changedtick
endfunction " }}}

augroup ely_statusline
  autocmd!
  autocmd CursorHold,BufWritePost * call s:refreshStatusLine()
  autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
  autocmd OptionSet spell call lightline#update()
augroup END

" }}}

" vim: fdm=marker
