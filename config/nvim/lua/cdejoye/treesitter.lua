-- Treesitter: https://github.com/nvim-treesitter/nvim-treesitter
-- TODO to auto close tags check: https://github.com/windwp/nvim-ts-autotag
require('packer').use {
  { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },
  'JoosepAlviste/nvim-ts-context-commentstring',
  'nvim-treesitter/nvim-treesitter-textobjects',
}

require('nvim-treesitter.configs').setup {
  ensure_installed = 'maintained', -- Install all maintained modules
  highlight = {
    enable = true,
     -- Needed for PHP correct indentation of method calls on multiple lines
     -- The indent module does not work correctly neither for my test, maybe it can be
     -- configured easily ?
    additional_vim_regex_highlighting = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = { enable = false },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['aC'] = '@class.outer',
        ['iC'] = '@class.inner',
        ['ac'] = '@conditional.outer',
        ['ic'] = '@conditional.inner',
        ['ae'] = '@block.outer',
        ['ie'] = '@block.inner',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
        ['is'] = '@statement.inner',
        ['as'] = '@statement.outer',
        ['ad'] = '@comment.outer',
        ['am'] = '@call.outer',
        ['im'] = '@call.inner',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>sa"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>sA"] = "@parameter.inner",
      },
    },
  },
  -- TODO check possible remplacement for vim-commentary:
  -- https://github.com/terrortylor/nvim-comment
  -- Config for it: https://github.com/JoosepAlviste/nvim-ts-context-commentstring#nvim-comment
  -- Or: https://github.com/b3nj5m1n/kommentary
  -- Config for it: https://github.com/b3nj5m1n/kommentary
  context_commentstring = { enable = true, config = { php = '// %s' } },
}

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
