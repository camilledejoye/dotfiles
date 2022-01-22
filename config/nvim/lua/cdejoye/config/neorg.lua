local workspaces = {
  default = '~/notes',
  wiki = '~/vimwiki',
  worldia ='~/work/worldia/api/notes'
}

require('neorg').setup {
  -- Tell Neorg what modules to load
  load = {
    ['core.defaults'] = {}, -- Load all the default modules

    ['core.norg.journal'] = { -- Easily create files for a journal
			-- https://github.com/nvim-neorg/neorg/wiki/Journal#Configuration
		},

    ['core.norg.qol.toc'] = { -- Generates a Table of Content from the Neorg file
			-- https://github.com/nvim-neorg/neorg/wiki/Qol-Toc
		},

    ['core.gtd.base'] = { -- Manages your tasks with Neorg using the Getting Things Done methodology
			-- https://github.com/nvim-neorg/neorg/wiki/Getting-Things-Done
		},

    ['core.presenter'] = { -- Neorg module to create gorgeous presentation slides
			-- https://github.com/nvim-neorg/neorg/wiki/Core-Presenter
		},



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
        workspaces = workspaces,
        autodetect = true,
        autochdir = true,
      },
    },

    ['core.integrations.telescope'] = {},
  },
}
