--- @module lazy
--- @type LazySpec
return { -- neogit
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'sindrets/diffview.nvim',
  },
  opts = {
    integrations = {
      telescope = true,
      diffview = true,
    },
    -- override/add mappings
    mappings = {
      -- modify status buffer mappings
      status = {
        ['za'] = 'Toggle',
        ['zM'] = 'Depth1',
        ['zR'] = 'Depth4',
        ['1'] = false,
        ['2'] = false,
        ['3'] = false,
        ['4'] = false,
      },
    },
  },
  keys = {
    {
      '<Leader>gs',
      function()
        require('neogit').open({ kind = 'auto' })
      end,
      desc = 'Open Neogit in a split',
    },
    {
      '<Leader>gS',
      function()
        require('neogit').open({ kind = 'tab' })
      end,
      desc = 'Open Neogit in a new tab',
    },
  },
}
