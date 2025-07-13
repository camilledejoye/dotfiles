local map = vim.api.nvim_set_keymap
local cmd = vim.cmd

-- Search {{{
-- Search for selected text, forwards or backwards.
-- http://vim.wikia.com/wiki/Search_for_visually_selected_text
map(
  'v',
  '*',
  [[:<C-U>let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>gvy/<C-R><C-R>=substitute(substitute(escape(@", '/\.*$^~['), '\v^\_s*(.{-})\_s*$', '\1', ''), '\_s\+', '\\_s\\+', 'g')<CR><CR>gV:call setreg('"', old_reg, old_regtype)<CR>]],
  { noremap = true, silent = true }
)
map(
  'v',
  '#',
  [[:<C-U> let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR> gvy?<C-R><C-R>=substitute( substitute(escape(@", '/\.*$^~['), '\v^\_s*(.{-})\_s*$', '\1', ''), '\_s\+', '\\_s\\+', 'g')<CR><CR> gV:call setreg('"', old_reg, old_regtype)<CR>
  ]],
  { noremap = true, silent = true }
)
-- }}}

-- Buffers {{{
-- <C-^> is a real pain on azerty keyboards...
map('n', '<C-h>', '<C-^>', { noremap = true, silent = true })

-- Quick access on some of the most used commands
map('n', '<Leader>w', ':w<CR>', { noremap = true, silent = true })
map('n', '<Leader>x', ':x<CR>', { noremap = true, silent = true })
map('n', '<Leader>q', ':q<CR>', { noremap = true, silent = true })
map('n', '<Leader>Q', ':qa<CR>', { noremap = true, silent = true })
map('i', ',w', '<Esc>:w<CR>', { noremap = true, silent = true })
map('i', ',x', '<Esc>:x<CR>', { noremap = true, silent = true })
map('i', ',q', '<Esc>:q<CR>', { noremap = true, silent = true })
-- }}}

-- Commands {{{
-- Delete the current buffer and open the alternate one in the current window
-- To be used as a command :bq<CR>
cmd([[cnoreabbrev <silent> bq b # <BAR> bd #]])

cmd([[cnoreabbrev f   find]])
cmd([[cnoreabbrev sf  sfind]])
cmd([[cnoreabbrev vsf vertical sfind]])
cmd([[cnoreabbrev tf  tabfind]])
cmd([[cnoreabbrev te  tabedit]])
cmd([[cnoreabbrev vst vsp term://]])
cmd([[cnoreabbrev spt sp term://]])
-- }}}

-- Folds {{{
-- Open all folds and close one level
-- Usefull to open everything but documentation block
map('n', 'zT', 'zR<BAR>zm<CR>', { noremap = true, silent = true })

-- Reset fold level, using 1 as default if non set
map('n', 'zI', ':let &foldlevel = (-1 < &foldlevelstart ? &foldlevelstart : 1)<CR>', { noremap = true, silent = true })
-- }}}

-- Terminal {{{
-- Close integrated terminal with Escape
map('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })
map('t', '<C-Esc>', [[<Esc>]], { noremap = true, silent = true })
map('t', '<S-Esc>', [[<Esc>]], { noremap = true, silent = true })
-- Works to make <CR> enter a new line in claudecode chat, the \ character is visible but claudecode says it
-- understand it as a line continuation and its not an issue
map('t', '<CR>', [[\<CR>]], { noremap = true, silent = true })
map('t', '<C-CR>', [[<CR>]], { noremap = true, silent = true })
map('t', '<S-CR>', [[<CR>]], { noremap = true, silent = true })
-- }}}

-- Miscellaneous {{{
-- Close all windows in the tab except for the current one
map('n', '<Leader>on', ':on<CR>', { noremap = true, silent = true })

map('n', '!', ':!', { noremap = true, silent = true })

map('n', '<C-l>', ':noh<CR>', { noremap = true, silent = true })

map('i', '<C-CR>', '<C-O>O', { noremap = true, silent = true })
map('i', '<S-CR>', '<C-O>o', { noremap = true, silent = true })
-- }}}

-- vim: ts=2 sw=2 et fdm=marker
