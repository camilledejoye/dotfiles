local function config(name)
  local cmd = [[cdejoye.config.%s]]

  return function()
    require(cmd:format(name))
  end
end

local function formatter(name)
  return function()
    local exists, opts = pcall(require, 'cdejoye.conform.formatters.'..name)

    return exists and opts or {}
  end
end

local ensure_lazy_is_installed = function()
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

ensure_lazy_is_installed()

require('lazy').setup({
  {
    'RRethy/nvim-base16',
    config = config('colorscheme'),
    priority = 999, -- A high number is recommended for colorscheme
  },

  -- Miscelanous
  'camilledejoye/vim-cleanfold',
  { 'kana/vim-niceblock', config = config('niceblock') },
  'terryma/vim-multiple-cursors',

  -- -- Disabled because I want to use Treesitter now, but I kept them here just in case
  -- -- Language related (syntax, completion,e tc.)
  -- 'elzr/vim-json',
  -- 'othree/csscomplete.vim',
  -- 'camilledejoye/vim-sxhkdrc',
  -- 'cespare/vim-toml',
  -- 'tbastos/vim-lua',

  { -- markdown-preview
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = function() vim.fn["mkdp#util#install"]() end,
    ft = { 'markdown' },
  },

  'wellle/targets.vim',  -- Adds a bunch of text objects, especially argument text object

  -- Add documentation around Lua
  'nanotee/luv-vimdocs',
  'milisims/nvim-luaref',

  'kyazdani42/nvim-web-devicons',

  { 'monaqa/dial.nvim', config = config('dial') }, -- Improved increment/decrement
  'tommcdo/vim-lion', -- Align text

  {
    'windwp/nvim-autopairs',
    config = config('autopairs'),
  },

  { -- Colorizer
    'norcalli/nvim-colorizer.lua',
    init = function()
      require('cdejoye.utils').map('yoC', '<cmd>ColorizerToggle<CR>')
    end,
    cmd = 'ColorizerToggle',
  },

  { -- Telescope
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-fzf-writer.nvim',
      'nvim-telescope/telescope-symbols.nvim',
    },
    config = config('telescope'),
  },

  -- -- I keep it around for now, it's interesting. It was easy to setup and more powerful than projectionist
  -- -- The mappings are actually stored in a `g:` vim variable
  -- -- So there should be a way to init the list on a per project basis
  -- { -- Alternative to projectionist
  --   'otavioschwanck/telescope-alternate',
  --   requires = 'nvim-telescope/telescope.nvim',
  --   opts = {
  --     open_only_one_with = 'vertical_split',
  --     mappings = {
  --       {
  --         'src/Planner/([^/]*)/(.*).php',
  --         {
  --           { 'tests/Planner/[1]/Unit/[2]Test.php', 'Unit test' },
  --           { 'tests/Planner/[1]/Integration/[2]Test.php', 'Integration test' },
  --           { 'tests/Planner/[1]/Acceptance/[2]Test.php', 'Acceptance test' },
  --         },
  --       },
  --       {
  --         'tests/Planner/([^/]*)/[^/]*/(.*)Test.php', -- The middle one is in replacement of: Unit|Integration|Acceptance
  --         { { 'src/Planner/[1]/[2].php', 'Source' } },
  --       },
  --     },
  --   },
  --   config = function (plugin, opts)
  --     require(plugin.name).setup(opts)
  --     require('telescope').load_extension(plugin.name)
  --   end,
  -- },

  { -- Debugger
    -- https://github.com/mfussenegger/nvim-dap
    -- PHP adapter installation: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#PHP
    'mfussenegger/nvim-dap',
    dependencies = {
      { 'rcarriga/nvim-dap-ui', dependencies = 'nvim-neotest/nvim-nio' },
      'theHamsta/nvim-dap-virtual-text',
      { 'nvim-telescope/telescope-dap.nvim', requires = 'nvim-telescope/telescope.nvim' },
    },
    config = config('dap'),
  },

  { 'gpanders/editorconfig.nvim' },

  { -- GitSigns
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = config('gitsigns'),
  },

  { -- neogit
    'TimUntersberger/neogit',
    -- 'camilledejoye/neogit', branch = 'folds-improvements',
    -- '~/work/vim/plugins/neogit',
    dependencies = 'nvim-lua/plenary.nvim',
    config = config('neogit'),
  },

  { -- diffview
    'sindrets/diffview.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    config = config('diffview'),
  },

  { 'rhysd/git-messenger.vim', config = config('git-messenger') },

  { "vhyrro/luarocks.nvim", priority = 1000, config = true },

  { -- Neorg
    'nvim-neorg/neorg',
    dependencies = {
      'vhyrro/luarocks.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neorg/neorg-telescope',
    },
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = '*', -- Pin Neorg to the latest stable release
    config = config('neorg'),
  },

  {
    'L3MON4D3/LuaSnip',
    build = 'make install_jsregexp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      {
        'benfowler/telescope-luasnip.nvim',
        config = function ()
          require('telescope').load_extension('luasnip')
        end,
      },
    },
    config = config('luasnip'),
  },

  { 'onsails/lspkind-nvim', config = config('lspkind') },

  { -- Completion manager
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
      -- Disable while testing LuaSnip
      -- 'quangnguyen30192/cmp-nvim-ultisnips',
      'hrsh7th/cmp-emoji',
      'f3fora/cmp-spell',
    },
    config = config('cmp'),
    priority = 100, -- default priority is 50 and this must be loaded before nvim-lspconfig to add cmp capabilities
  },

  -- LSP
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  { -- 3rd party installer
    'williamboman/mason.nvim',
  },
  'williamboman/mason-lspconfig.nvim',
  'jayp0521/mason-nvim-dap.nvim',
  -- 'jayp0521/mason-null-ls.nvim',
  {
    'neovim/nvim-lspconfig',
    config = config('lspconfig'),
  },
  'ray-x/lsp_signature.nvim',
  { 'glepnir/lspsaga.nvim', config = config('lspsaga') },
  -- -- Keep it close in case of issue to be able to quickly go back to a working state
  -- 'jose-elias-alvarez/null-ls.nvim',
  {
    'stevearc/conform.nvim',
    cmd = { "ConformInfo" },
    keys = {
      {
        '<Leader>ff',
        function() require('conform').format({ async = true }) end,
        mode = "",
        desc = 'Format buffer',
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      -- Set default options
      default_format_opts = {
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        php = { 'php_cs_fixer' },
        sql = { 'sql_formatter' },
        python = { 'isort', 'black' },
      },
      formatters = {
        php_cs_fixer = formatter('php_cs_fixer'),
      },
    },
  },
  { 'zapling/mason-conform.nvim', opts = {
    -- Usually installed per project to have specific versions
    ignore_install = { 'phpcbf', 'phpcs', 'phpstan', 'php_cs_fixer' },
  } },
  {
    'mfussenegger/nvim-lint',
    -- dev = true,
    config = config('nvim-lint'),
  },
  {
    'rshkarin/mason-nvim-lint',
    opts = {
      -- Usually installed per project to have specific versions
      ignore_install = { 'phpstan', 'php_cs_fixer', 'phpcs' },
    },
  },
  'camilledejoye/nvim-lsp-selection-range',
  'b0o/schemastore.nvim', -- used by jsonls server to retrieve json schemas
  {
    'mfussenegger/nvim-jdtls',
    -- To try, disable for now in case it's laoded after the ftype/java config
    -- from an example, I should be able to move the ftype config into my plugin config using ft = java here
    -- ft = 'java',
    -- config = config('jdtls')
  },

  { -- trouble
    'folke/trouble.nvim',
    opts = {},
    cmd = 'Trouble',
    keys = {
      {
        '<Leader>sD',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<Leader>sd',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<Leader>sS',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<Leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<Leader>lw',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<Leader>cw',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },

  { -- Phpactor
    'phpactor/phpactor',
    build = 'composer install -o',
    dependencies = {
      'camilledejoye/phpactor-mappings',
      'junegunn/fzf.vim',
      { 'junegunn/fzf', build = 'fzf#install' },
    },
    config = config('phpactor'),
  },

  {
    'camilledejoye/vim-php-refactoring-toolbox',
    branch = 'improvements',
    config = function ()
      local map = require('cdejoye.utils').map
      vim.g.vim_php_refactoring_use_default_mapping = 0
      map('<Leader>pi', [[<cmd>call PhpInline()<CR>]])
    end,
  },

  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = false,
    config = function()
      require("refactoring").setup()
    end,
  },

  -- { -- Snippets
  --   -- 'SirVer/ultisnips', -- The engine
  --   'camilledejoye/ultisnips', branch = 'develop', -- Until the handling of floating windows is fixed
  --   dependencies = {
  --     'honza/vim-snippets', -- The snippets definitions
  --     { -- PHP snippets
  --       'sniphpets/sniphpets',
  --       dependencies = {
  --         'sniphpets/sniphpets-common',
  --         'sniphpets/sniphpets-symfony',
  --         'sniphpets/sniphpets-phpunit',
  --         'sniphpets/sniphpets-doctrine',
  --         'sniphpets/sniphpets-postfix-codes',
  --       },,
  --       config = function()
  --         -- Disable because mappings starting with ; causes issues with lsp-signature
  --         -- The timeout for the mapping resolution make the popup window appears again
  --         vim.g.sniphpets_common_disable_shortcuts = 1
  --       end,
  --     },,
  --   },,
  --   config = function()
  --     vim.g.UltiSnipsExpandTrigger		= "<Tab>"
  --     vim.g.UltiSnipsJumpForwardTrigger	= "<C-j>"
  --     vim.g.UltiSnipsJumpBackwardTrigger	= "<C-k>"
  --     vim.g.UltiSnipsRemoveSelectModeMappings = 0
  --   end,
  -- },

  { 'stevearc/dressing.nvim', config = config('dressing') },

  -- { -- noice
  --   "folke/noice.nvim",
  --   dependencies = { "MunifTanjim/nui.nvim" },
  --   config = config('noice'),
  --   -- I had issues when having invalid Lua somewhere
  --   -- Neovim was closing without showing any message and it seems to be because of noice
  --   -- This seems to have helped, experience will tell
  --   event = 'VimEnter',
  -- },

  { -- lualine
    'hoob3rt/lualine.nvim',
    after = 'nvim-base16',
    dependencies = {
      { 'kyazdani42/nvim-web-devicons', lazy = true},
    },
    config = config('lualine'),
  },

  -- TODO try again later
  -- There is no equivalent to `gcu` by default, we should do it ourserlves using a textobject
  -- from another plugin, for instance a treesitter extension
  -- { 'numToStr/Comment.nvim', config = config('comment') }

  { -- tpope plugins
    { 'tpope/vim-surround', setup = function() vim.g.surround_no_insert_mappings = true end },
    'tpope/vim-commentary',
    { 'tpope/vim-scriptease', cmd = 'Scriptnames' },
    { 'tpope/vim-unimpaired', config = config('unimpaired') },
    'tpope/vim-abolish',
    { 'tpope/vim-fugitive', config = config('fugitive') },
    'tpope/vim-repeat',
    'tpope/vim-dispatch',
    'radenling/vim-dispatch-neovim',
    { 'tpope/vim-projectionist', config = config('projectionist') },
    'tpope/vim-eunuch',
  },

  { -- Treesitter
    -- TODO to auto close tags check: https://github.com/windwp/nvim-ts-autotag
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' },
    },
    config = config('nvim-treesitter'),
  },

  {
    'nvim-treesitter/playground',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },

  { -- vim-argwrap
    -- 'FooSoft/vim-argwrap',
    'camilledejoye/vim-argwrap', branch = 'imp/php-always-tail-comma-for-method-declaration',
    config = config('vim-argwrap'),
  },

  {
    'andythigpen/nvim-coverage',
    dependencies = 'nvim-lua/plenary.nvim',
    rocks = { 'lua-xmlreader' },
    config = config('coverage'),
    cmd = {
      'Coverage',
      'CoverageHide',
      'CoverageLoad',
      'CoverageShow',
      'CoverageClear',
      'CoverageToggle',
      'CoverageSummary',
    },
    keys = { '<leader>tc', '<leader>tC' },
  },

  { -- vim-test
    -- 'vim-test/vim-test',
    'camilledejoye/vim-test', branch = 'phpunit-attributes',
    -- '~/work/vim/plugins/vim-test',
    config = config('vim-test'),
  },

  -- -- Keep vim-test for a reliable environment, it works great with containers and provide
  -- -- a nice fast feedback loop
  -- -- Neotest is a nice idea but would require work to be able to operate properly and seamlessly
  -- -- with containers
  -- {
  --   "nvim-neotest/neotest",
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'nvim-treesitter/nvim-treesitter',
  --     'antoinemadec/FixCursorHold.nvim',
  --     'nvim-neotest/neotest-plenary',
  --     -- 'olimorris/neotest-phpunit',
  --     '~/work/vim/plugins/neotest-phpunit',
  --     -- 'nvim-neotest/neotest-vim-test',
  --     -- 'vim-test/vim-test', -- To fallback if no adapter exists
  --   },,
  --   config = config('neotest'),
  -- },

  { -- lir.nvim
    'tamago324/lir.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'tamago324/lir-bookmark.nvim',
    },
    config = config('lir'),
  },

  {
    'rcarriga/nvim-notify',
    config = function()
      local notify = require('notify')
      notify.setup({
        -- suggested by the plugin for 100% transparency after an update, to test eventually
        background_colour = '#000000'
      })

      -- vim.notify = notify.notify

      if pcall(require, 'telescope') then
        require('telescope').load_extension('notify')
      end
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
}, {
  dev = {
    path = '~/work/nvim-plugins',
  },
})
