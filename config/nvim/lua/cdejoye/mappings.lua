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

-- Native Snippets (Experimental) {{{
-- WARNING: These mappings may conflict with LuaSnip's dynamic mappings
-- LuaSnip creates <C-j>/<C-k> mappings when a snippet is expanded and removes
-- them when leaving the snippet. Consider implementing similar dynamic behavior
-- for native snippets to avoid permanent mapping conflicts.
-- For now, accepting overlap for manual testing purposes.

-- Expand native snippet for current word under cursor
map('i', '<C-S-s>', '', {
  noremap = true,
  silent = true,
  callback = function()
    local completion_provider = require('native-snippets.completion_provider')
    local items = completion_provider.get_items_for_filetype(vim.bo.filetype)

    -- Get the word under cursor
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local before_cursor = line:sub(1, col)
    local word = before_cursor:match('(%S+)$') or ''

    -- Find matching snippet
    for _, item in ipairs(items) do
      if item.label == word then
        -- Replace the word with the snippet
        local start_col = col - #word
        vim.api.nvim_buf_set_text(
          0,
          vim.api.nvim_win_get_cursor(0)[1] - 1,
          start_col,
          vim.api.nvim_win_get_cursor(0)[1] - 1,
          col,
          {}
        )
        vim.snippet.expand(item.insertText)
        return
      end
    end

    -- No snippet found, show available snippets
    local labels = {}
    for _, item in ipairs(items) do
      table.insert(labels, item.label)
    end
    print('Available snippets: ' .. table.concat(labels, ', '))
  end,
})

-- Jump to next snippet placeholder
map('i', '<C-j>', '', {
  noremap = true,
  silent = true,
  callback = function()
    if vim.snippet.active({ direction = 1 }) then
      vim.snippet.jump(1)
    end
  end,
})
map('s', '<C-j>', '', {
  noremap = true,
  silent = true,
  callback = function()
    if vim.snippet.active({ direction = 1 }) then
      vim.snippet.jump(1)
    end
  end,
})

-- Jump to previous snippet placeholder
map('i', '<C-k>', '', {
  noremap = true,
  silent = true,
  callback = function()
    if vim.snippet.active({ direction = -1 }) then
      vim.snippet.jump(-1)
    end
  end,
})
map('s', '<C-k>', '', {
  noremap = true,
  silent = true,
  callback = function()
    if vim.snippet.active({ direction = -1 }) then
      vim.snippet.jump(-1)
    end
  end,
})
-- }}}

-- vim: ts=2 sw=2 et fdm=marker
