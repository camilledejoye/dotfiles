--- @module lazy
--- @type LazySpec
return {
  -- TODO to auto close tags check: https://github.com/windwp/nvim-ts-autotag
  'nvim-treesitter/nvim-treesitter',
  branch = 'master', -- Make sure to specify the master branch, as the default branch will switch to main in the future
  lazy = false, -- does not support lazy-loading
  build = ':TSUpdate',
  init = function()
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.opt.foldenable = false
  end,
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
  end,
  opts = {
    ensure_installed = {
      'bash',
      'caddy',
      -- 'comment', -- Apparently it's slow
      'css',
      'diff',
      'dockerfile',
      'editorconfig',
      'git_config',
      'git_rebase',
      'gitattributes',
      'gitcommit',
      'gitignore',
      'helm',
      'hjson',
      'html',
      'http',
      'ini',
      'java',
      'javadoc',
      'javascript',
      'jq',
      'jsdoc',
      'json',
      'json5',
      'jsonc',
      'lua',
      'luadoc',
      'make',
      'markdown',
      'markdown_inline',
      'mermaid',
      'php',
      'phpdoc',
      'python',
      'regex',
      'scss',
      'sql',
      'sxhkdrc',
      'terraform',
      'toml',
      'tsx',
      'twig',
      'typescript',
      'vim',
      'vimdoc',
      'xml',
      'xresources',
      'yaml',
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (or "all")
    ignore_install = {},

    modules = {},

    highlight = {
      enable = true,
      -- Needed for correct indentation of method calls on multiple lines and phpdoc
      additional_vim_regex_highlighting = { 'php' },
    },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'gnn',
        node_incremental = 'grn',
        scope_incremental = 'grc',
        node_decremental = 'grm',
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
          ['<leader>al'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>ah'] = '@parameter.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@custom_structure.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@custom_structure.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@custom_structure.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@custom_structure.outer',
        },
      },
    },
  },
}
