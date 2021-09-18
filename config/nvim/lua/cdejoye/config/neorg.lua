require('neorg').setup {
  -- Tell Neorg what modules to load
  load = {
    ['core.defaults'] = {}, -- Load all the default modules

    ['core.norg.completion'] = { config = { engine = 'nvim-cmp' } },

    ['core.keybinds'] = { -- Configure core.keybinds
      config = {
        default_keybinds = true, -- Generate the default keybinds
        neorg_leader = '<Leader>o', -- This is the default if unspecified
      },
    },

    ['core.norg.concealer'] = { -- Allows for use of icons
      config = {
        icons = {
          todo = {
            pending = { icon = ' ' },
          },
        },
      },
    },

    ['core.integrations.treesitter'] = {
      config = {
        highlights = {
          TodoItem = {
            ['1'] = {
              Undone = '+TSError',
              Pending = '+TSPunctDelimiter',
            },
            ['2'] = {
              Undone = '+TSError',
              Pending = '+TSPunctDelimiter',
            },
            ['3'] = {
              Undone = '+TSError',
              Pending = '+TSPunctDelimiter',
            },
            ['4'] = {
              Undone = '+TSError',
              Pending = '+TSPunctDelimiter',
            },
            ['5'] = {
              Undone = '+TSError',
              Pending = '+TSPunctDelimiter',
            },
            ['6'] = {
              Undone = '+TSError',
              Pending = '+TSPunctDelimiter',
            },
          },
        },
      },
    },

    ['core.norg.dirman'] = { -- Manage your directories with Neorg
      config = {
        workspaces = {
          my_workspace = '~/notes',
          wiki = '~/vimwiki',
          wynd = '~/work/wynd/.notes',
        },
        autodetect = true,
        autochdir = true,
      },
    },

    ['core.integrations.telescope'] = {},
  },
}
