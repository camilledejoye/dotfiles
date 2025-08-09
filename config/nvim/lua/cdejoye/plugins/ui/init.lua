--- @module lazy
--- @type LazySpec[]
return {
  require('cdejoye.plugins.ui.tree-sitter'),
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  require('cdejoye.plugins.ui.lualine'),
  'camilledejoye/vim-cleanfold',

  -- Feels a bit slow, I think i would rather setup want I want individually for now
  -- { -- noice
  --   'folke/noice.nvim',
  --   dependencies = {
  --     'MunifTanjim/nui.nvim',
  --     'rcarriga/nvim-notify',
  --   },
  --   event = 'VeryLazy',
  --   config = config('noice'),
  -- },

  {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    init = function()
      vim.notify = require('notify').notify
    end,
    opts = {
      -- I had this notification otherwise:
      -- Please provide an RGB hex value or highlight group with a background value for 'background_colour' option.
      -- This is the colour that will be used for 100% transparency.
      -- ```lua
      -- require("notify").setup({
      --   background_colour = "#000000",
      -- })
      -- ```
      background_colour = "#000000",
    },
    keys = {
      {
        '<S-Escape>',
        function()
          require('notify').dismiss({ silent = true, pending = true })
        end,
      }
    },
  },

  -- { -- notifier.nvim
  --   '~/work/vim/plugins/notifier.nvim',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --   },,
  --   config = function()
  --     require('notifier').setup {
  --       adapter = require('notifier.adapters.nvim-notify'),
  --       -- adapter = require('notifier.adapters.gdbus'),
  --       use_globally = true,
  --       extensions = {
  --         lsp = {
  --           enabled = true,
  --         },,
  --       },,
  --     },
  --   end,
  -- },
}
