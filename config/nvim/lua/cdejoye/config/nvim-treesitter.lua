-- To run before: require('nvim-treesitter.configs').setup()
-- https://github.com/vhyrro/neorg#setting-up-treesitter

require('nvim-treesitter.configs').setup {
  ensure_installed = 'all', -- Install all modules, allows to include norg which is not part of maintained

  highlight = {
    enable = true,
     -- Needed for correct indentation of method calls on multiple lines and phpdoc
    additional_vim_regex_highlighting = { 'php' },
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

  indent = {
    enable = false,
    disable = {
      'php', -- Does not work for method calls on multiple lines and phpdoc
    },
  },

  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
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
      -- Only works when used in operator pending mode
      -- Example to select a function characterwise `vaf`, linewise `Vaf`
      -- To use the following config `daf`
      selection_modes = {
        ['@function.inner'] = 'V',
        ['@function.outer'] = 'V',
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding xor succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      include_surrounding_whitespace = false,
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
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@custom_structure.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@custom_structure.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@custom_structure.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@custom_structure.outer",
      },
    },
  },

  -- Update commentrstring option inside a file based on the cursor location
  -- For example when commenting some SQL inside a PHP file, CSS inside HTML, etc.
  context_commentstring = { enable = true },
}

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldenable = false
