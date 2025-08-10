--- @module lazy
--- @type LazySpec[]
return {
  {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    init = function()
      vim.notify = require('notify').notify
    end,
    opts = {
      background_colour = '#000000', -- To avoid warning for background transparency
    },
    keys = {
      {
        '<S-Escape>',
        function()
          require('notify').dismiss({ silent = true, pending = true })
        end,
      },
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
