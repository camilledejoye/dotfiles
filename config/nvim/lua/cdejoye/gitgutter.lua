-- vim: ts=2 sw=2 et

require('packer').use {
  'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('gitsigns').setup ({
      signs = {
        add          = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
        change       = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
      },
      keymaps = {
        -- Default keymap options
        noremap = true,

        ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
        ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

        ['n <Leader>sh'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
        ['v <Leader>sh'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
        -- ['n <Leader>uh'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
        ['n <Leader>uh'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
        ['v <Leader>uh'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
        -- ['n <Leader>Rh'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
        ['n <Leader>ph'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
        -- ['n <Leader>bh'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
        -- ['n <Leader>Sh'] = '<cmd>lua require"gitsigns".stage_buffer()<CR>',
        -- ['n <Leader>Uh'] = '<cmd>lua require"gitsigns".reset_buffer_index()<CR>',

        -- Text objects
        ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
        ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
      },
      watch_index = {
        interval = 250,
        follow_files = true
      },
    })
  end
}
