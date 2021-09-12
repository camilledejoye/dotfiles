-- To run before: require('nvim-treesitter.configs').setup()
-- https://github.com/vhyrro/neorg#setting-up-treesitter
require('nvim-treesitter.parsers').get_parser_configs().norg = {
  install_info = {
    url = 'https://github.com/vhyrro/tree-sitter-norg',
    files = { 'src/parser.c', 'src/scanner.cc' },
    branch = 'main'
  },
}

require('nvim-treesitter.configs').setup {
  ensure_installed = 'all', -- Install all modules, allows to include norg which is not part of maintained
  ignore_install = { 'fennel' }, -- I had errors in checkheal for this one

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

  indent = { enable = true },

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

  -- Update commentrstring option inside a file based on the cursor location
  -- For example when commenting some SQL inside a PHP file, CSS inside HTML, etc.
  context_commentstring = { enable = true },
}

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
