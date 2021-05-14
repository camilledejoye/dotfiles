function! s:addErrorHighlight() abort
  if !exists('g:loaded_lightline')
    return
  endif

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
endfunction

call s:addErrorHighlight()