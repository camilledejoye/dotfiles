local workspaces = {
  default = '~/notes',
  wiki = '~/vimwiki',
  worldia ='~/work/worldia/platform/api/notes',
  tasks = '~/work/worldia/platform/api/notes/tasks',
}

local map = require('cdejoye.utils').map

map('<Leader>nw', '<cmd>Telescope neorg switch_workspace<CR>')
map('<Leader>ni', '<cmd>Neorg index<CR>')
map('<Leader>nt', '<cmd>Neorg workspace tasks<CR>')
map('<Leader>nr', '<cmd>Neorg return<CR>')
map('<Leader>sn', '<cmd>Telescope neorg find_norg_files<CR>')

require('neorg').setup {
  -- Tell Neorg what modules to load
  load = {
    ['core.defaults'] = {}, -- Load all the default modules

    ['core.journal'] = { -- Easily create files for a journal
      -- https://github.com/nvim-neorg/neorg/wiki/Journal#Configuration
    },

    ['core.qol.toc'] = { -- Generates a Table of Content from the Neorg file
      -- https://github.com/nvim-neorg/neorg/wiki/Qol-Toc
    },

    ['core.qol.todo_items'] = {
      config = {
        order = {{'undone', ' '}, {'pending', '-'}, {'done', 'x'}},
      },
    },

    -- ['core.presenter'] = { -- Neorg module to create gorgeous presentation slides
    --   config = { -- https://github.com/nvim-neorg/neorg/wiki/Core-Presenter
    --     zen_mode = 'zen-mode',
    --   },
    -- },

    ['core.export'] = {}, -- Export into a different format

    ['core.summary'] = {}, -- Generates summary for the entire workspace

    ['core.completion'] = { config = { engine = 'nvim-cmp' } },

    ['core.keybinds'] = { -- Configure core.keybinds
      config = {
        default_keybinds = true, -- Generate the default keybinds
        neorg_leader = '<Leader>o', -- Default is <LocalLeader>
      },
    },

    ['core.concealer'] = { -- Allows for use of icons
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

    ['core.dirman'] = { -- Manage your directories with Neorg
      config = {
        workspaces = workspaces,
        autodetect = true,
        autochdir = true,
        default_workspace = 'worldia',
      },
    },

    ['core.integrations.telescope'] = {},
  },
}
