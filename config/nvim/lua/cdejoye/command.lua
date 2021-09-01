vim.cmd([[
augroup ely_custom_commands
  " Convenient command to see the difference between the current buffer and the
  " file it was loaded from, thus the changes you made.
  " Only define it when not defined already.
  " Revert with: ":delcommand DiffOrig".
  if !exists(":DiffOrig")
      command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
  endif

  " Delete all trailling spaces on write
  " autocmd BufWritePre * %s/\s\+$//e

  " jump to last position in file
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "keepjumps normal g`\"" | endif
augroup END
]])

-- vim: ts=2 sw=2 et fdm=marker
