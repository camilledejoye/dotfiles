local g = vim.g

require('packer').use('FooSoft/vim-argwrap')

vim.api.nvim_set_keymap('n', 'gaw', '<Plug>(ArgWrapToggle)', { silent = true })

-- Also add a comma to the last item after wrapping for the listed pairs
g.argwrap_tail_comma_braces = '['
-- Wrap/Unwrap the opening brace of a method
g.argwrap_php_smart_brace = 1
-- Until PHP 8 function and method declarations can't have a trailing comma
-- This option removes it so that we can still use argwrap to add it to
-- function and method calls
g.argwrap_php_remove_tail_comma_function_declaration = 1

vim.cmd([[
augroup ely_argwrap
  autocmd!
  autocmd FileType vim let b:argwrap_line_prefix = '\ '
  " Since PHP 7.3 function and method calls can have a traling comma
  autocmd FileType php let b:argwrap_tail_comma_braces = g:argwrap_tail_comma_braces .'('

  " Enable tail comma in Lua
  autocmd FileType lua let b:argwrap_tail_comma_braces = g:argwrap_tail_comma_braces .'{'
  autocmd FileType lua let b:argwrap_padded_braces = g:argwrap_tail_comma_braces .'{['
augroup END
]])

-- vim: ts=2 sw=2 et fdm=marker
