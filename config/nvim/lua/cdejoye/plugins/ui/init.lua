--- @module lazy
--- @type LazySpec[]
return {
  require('cdejoye.plugins.ui.tree-sitter'),
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
