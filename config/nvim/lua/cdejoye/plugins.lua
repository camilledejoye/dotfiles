local function config(name)
  local cmd = [[require('cdejoye.config.%s')]]

  return cmd:format(name)
end

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use { 'wbthomason/packer.nvim' }

  use { 'lewis6991/impatient.nvim' }

  use { 'RRethy/nvim-base16', config = config('colorscheme') }

  use { -- Miscelanous
    'camilledejoye/vim-cleanfold',
    { 'kana/vim-niceblock', config = config('niceblock') },
    'terryma/vim-multiple-cursors',
  }

  -- Disabled because I want to use Treesitter now, but I kept them here just in case
  -- use { -- Language related (syntax, completion,e tc.)
  --   'elzr/vim-json',
  --   'othree/csscomplete.vim',
  --   'camilledejoye/vim-sxhkdrc',
  --   'cespare/vim-toml',
  --   'tbastos/vim-lua',
  -- }

  use { -- markdown-preview
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install',
    cmd = 'MarkdownPreview',
    ft = 'markdown',
  }

  use 'wellle/targets.vim'  -- Adds a bunch of text objects, especially argument text object

  use { -- Fix CursorHold performance issue on Neovim:
    -- https://github.com/antoinemadec/FixCursorHold.nvim
    -- See: https://github.com/neovim/neovim/issues/12587
    "antoinemadec/FixCursorHold.nvim",
    setup = [[vim.g.cursorhold_updatetime = 100]]
  }

  use { -- Add documentation around Lua
    'nanotee/luv-vimdocs',
    'milisims/nvim-luaref',
  }

  use { 'kyazdani42/nvim-web-devicons' }

  use { 'monaqa/dial.nvim', config = config('dial') } -- Improved increment/decrement
  use { 'tommcdo/vim-lion' } -- Align text

  use {
    'windwp/nvim-autopairs',
    config = config('autopairs'),
  }

  use { -- Colorizer
    'norcalli/nvim-colorizer.lua',
    setup = [[require('cdejoye.utils').map('yoC', '<cmd>ColorizerToggle<CR>')]],
    cmd = 'ColorizerToggle',
  }

  use { -- Debugger
    -- https://github.com/mfussenegger/nvim-dap
    -- PHP adapter installation: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#PHP
    -- TODO use post install hook to run a script using plenary.nvim to install it automatically
    'mfussenegger/nvim-dap',
    requires = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      { 'nvim-telescope/telescope-dap.nvim', require = 'nvim-telescope/telescope.nvim' },
    },
    config = config('dap'),
  }

  use { 'gpanders/editorconfig.nvim' }

  use { -- GitSigns
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = config('gitsigns'),
  }

  use { -- neogit
    -- 'TimUntersberger/neogit',
    'camilledejoye/neogit', branch = 'folds-improvements',
    -- '~/work/vim/plugins/neogit',
    requires = 'nvim-lua/plenary.nvim',
    config = config('neogit'),
  }

  use { -- diffview
    'sindrets/diffview.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = config('diffview'),
  }

  use { 'rhysd/git-messenger.vim', config = config('git-messenger') }

  use { -- Neorg
    'nvim-neorg/neorg',
    run = ":Neorg sync-parsers",
    -- No more unstable branch in new repo ?
    -- branch = 'unstable',
    requires = { 'nvim-lua/plenary.nvim', 'vhyrro/neorg-telescope' },
    after = 'nvim-treesitter',
    config = config('neorg'),
  }

  use {
    'L3MON4D3/LuaSnip',
    -- requires = { 'rafamadriz/friendly-snippets' },
    config = config('luasnip'),
  }

  use { 'onsails/lspkind-nvim', config = config('lspkind') }

  use { -- Completion manager
    'hrsh7th/nvim-cmp',
    requires = {
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
  }

  use { -- LSP
    'folke/neodev.nvim', -- Help configuring sumneko lua language server
    'williamboman/mason.nvim', -- 3rd party installer
    'williamboman/mason-lspconfig.nvim',
    'jayp0521/mason-nvim-dap.nvim',
    'jayp0521/mason-null-ls.nvim',
    {
      'neovim/nvim-lspconfig',
      after = { 'nvim-cmp' }, -- To be able to add cmp capabilities it must be loaded first
      config = config('lspconfig'),
    },
    'ray-x/lsp_signature.nvim',
    { 'glepnir/lspsaga.nvim', config = config('lspsaga') },
    { 'jose-elias-alvarez/null-ls.nvim', config = config('null-ls') },
    { 'camilledejoye/nvim-lsp-selection-range' },
    { 'b0o/schemastore.nvim' }, -- used by jsonls server to retrieve json schemas
  }

  use { -- Phpactor
    'phpactor/phpactor',
    run = 'composer install -o',
    requires = { 'camilledejoye/phpactor-mappings' },
    config = config('phpactor'),
  }

  use {
    'camilledejoye/vim-php-refactoring-toolbox',
    branch = 'improvements',
    config = function ()
      local map = require('cdejoye.utils').map
      vim.g.vim_php_refactoring_use_default_mapping = 0
      map('<Leader>pi', [[<cmd>call PhpInline()<CR>]])
    end,
  }

  -- use { -- Snippets
  --   -- 'SirVer/ultisnips', -- The engine
  --   'camilledejoye/ultisnips', branch = 'develop', -- Until the handling of floating windows is fixed
  --   requires = {
  --     'honza/vim-snippets', -- The snippets definitions
  --     { -- PHP snippets
  --       'sniphpets/sniphpets',
  --       requires = {
  --         'sniphpets/sniphpets-common',
  --         'sniphpets/sniphpets-symfony',
  --         'sniphpets/sniphpets-phpunit',
  --         'sniphpets/sniphpets-doctrine',
  --         'sniphpets/sniphpets-postfix-codes',
  --       },
  --       config = function()
  --         -- Disable because mappings starting with ; causes issues with lsp-signature
  --         -- The timeout for the mapping resolution make the popup window appears again
  --         vim.g.sniphpets_common_disable_shortcuts = 1
  --       end,
  --     },
  --   },
  --   config = function()
  --     vim.g.UltiSnipsExpandTrigger		= "<Tab>"
  --     vim.g.UltiSnipsJumpForwardTrigger	= "<C-j>"
  --     vim.g.UltiSnipsJumpBackwardTrigger	= "<C-k>"
  --     vim.g.UltiSnipsRemoveSelectModeMappings = 0
  --   end,
  -- }

  use { -- Telescope
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      'nvim-telescope/telescope-fzf-writer.nvim',
      'nvim-telescope/telescope-symbols.nvim',
    },
    config = config('telescope'),
  }

  use { 'stevearc/dressing.nvim', config = config('dressing') }

  use { -- lualine
    'hoob3rt/lualine.nvim',
    after = 'nvim-base16',
    requires = {
      { 'kyazdani42/nvim-web-devicons', opt = true},
    },
    config = config('lualine'),
  }

  -- TODO try again later
  -- There is no equivalent to `gcu` by default, we should do it ourserlves using a textobject
  -- from another plugin, for instance a treesitter extension
  -- use { 'numToStr/Comment.nvim', config = config('comment') }

  use { -- tpope plugins
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
  }

  use { -- Treesitter
    -- TODO to auto close tags check: https://github.com/windwp/nvim-ts-autotag
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = config('nvim-treesitter'),
  }

  use {
    'nvim-treesitter/playground',
    requires = { 'nvim-treesitter/nvim-treesitter' },
  }

  use { -- vim-argwrap
    -- 'FooSoft/vim-argwrap',
    'camilledejoye/vim-argwrap', branch = 'imp/php-always-tail-comma-for-method-declaration',
    config = config('vim-argwrap'),
  }

  use {
    -- 'andythigpen/nvim-coverage',
    'camilledejoye/nvim-coverage', branch = 'feat/php-cobertura',
    -- '~/work/vim/plugins/nvim-coverage',
    requires = 'nvim-lua/plenary.nvim',
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
  }

  use { -- vim-test
    -- 'vim-test/vim-test',
    'camilledejoye/vim-test', branch = 'phpunit-attributes',
    -- '~/work/vim/plugins/vim-test',
    config = config('vim-test'),
  }

  -- -- Keep vim-test for a reliable environment, it works great with containers and provide
  -- -- a nice fast feedback loop
  -- -- Neotest is a nice idea but would require work to be able to operate properly and seamlessly
  -- -- with containers
  -- use {
  --   "nvim-neotest/neotest",
  --   requires = {
  --     'nvim-lua/plenary.nvim',
  --     'nvim-treesitter/nvim-treesitter',
  --     'antoinemadec/FixCursorHold.nvim',
  --     'nvim-neotest/neotest-plenary',
  --     -- 'olimorris/neotest-phpunit',
  --     '~/work/vim/plugins/neotest-phpunit',
  --     -- 'nvim-neotest/neotest-vim-test',
  --     -- 'vim-test/vim-test', -- To fallback if no adapter exists
  --   },
  --   config = config('neotest'),
  -- }

  use { -- lir.nvim
    'tamago324/lir.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'tamago324/lir-bookmark.nvim',
    },
    config = config('lir'),
  }

  use {
    'ahmedkhalf/project.nvim',
    requires = { 'nvim-telescope/telescope.nvim' },
    config = config('project'),
  }

  use {
    'rcarriga/nvim-notify',
    config = function()
      -- vim.notify = require('notify').notify

      if pcall(require, 'telescope') then
        require('telescope').load_extension('notify');
      end
    end,
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
