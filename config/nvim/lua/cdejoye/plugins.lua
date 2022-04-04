local function config(name)
  local cmd = [[require('cdejoye.config.%s')]]

  return cmd:format(name)
end

-- Install packer if not already present - allow to install from the AUR
if not pcall(require, 'packer') then
  local package_root = vim.fn.stdpath('data') .. '/site/pack' -- default value in packer
  local packer_path = package_root .. '/packer/opt/packer.nvim'

  print('Installing packer.nvim ...')
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', packer_path})
  vim.cmd('packadd packer.nvim')
end

return require('packer').startup({ function(use)
  use { 'RRethy/nvim-base16', config = config('colorscheme') }

  use { -- Packer can manage itself
    'wbthomason/packer.nvim',
    cmd = { 'PackerInstall', 'PackerUpdate', 'PackerSync', 'PackerClean', 'PackerCompile' },
  }

  use { -- Miscelanous
    'camilledejoye/vim-cleanfold',
    { 'kana/vim-niceblock', config = config('niceblock') },
    'terryma/vim-multiple-cursors',
    { 'junegunn/vader.vim', opt = true },
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

  use('wellle/targets.vim') -- Adds a bunch of text objects, especially argument text object

  use { -- Fix CursorHold performance issue on Neovim:
    -- https://github.com/antoinemadec/FixCursorHold.nvim
    -- See: https://github.com/neovim/neovim/issues/12587
    "antoinemadec/FixCursorHold.nvim",
    setup = [[vim.g.cursorhold_updatetime = 1000]]
  }

  use { -- Add documentation around Lua
    'nanotee/luv-vimdocs',
    'milisims/nvim-luaref',
    'folke/lua-dev.nvim', -- Help configuring sumneko lua language server
  }

  use { 'kyazdani42/nvim-web-devicons' }

  use { 'monaqa/dial.nvim', config = config('dial') } -- Improved increment/decrement
  use('tommcdo/vim-lion') -- Align text

  use { 'jiangmiao/auto-pairs', config = config('auto-pairs') }

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

  use{ 'rhysd/git-messenger.vim', config = config('git-messenger') }

  use { -- Neorg
    'nvim-neorg/neorg',
    -- No more unstable branch in new repo ?
    -- branch = 'unstable',
    requires = { 'nvim-lua/plenary.nvim', 'vhyrro/neorg-telescope' },
    after = 'nvim-treesitter',
    config = config('neorg'),
  }

  -- use {
  --   'L3MON4D3/LuaSnip',
  --   -- requires = { 'rafamadriz/friendly-snippets' },
  --   config = config('luasnip'),
  -- }

  use { 'onsails/lspkind-nvim', config = config('lspkind') }

  use { -- Completion manager
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'ray-x/lsp_signature.nvim',
      -- Disable while I'm still using UltiSnips (no need for LSP)
      -- 'saadparwaiz1/cmp_luasnip',
      -- 'L3MON4D3/LuaSnip',
      'quangnguyen30192/cmp-nvim-ultisnips',
      'hrsh7th/cmp-emoji',
      'f3fora/cmp-spell',
    },
    config = config('cmp'),
  }

  use { -- nvim-lspconfig
    'neovim/nvim-lspconfig',
    after = { 'nvim-cmp' }, -- use an alias like completor to be more generic ?
    requires = {
      { 'nvim-lua/lsp-status.nvim', config = config('lsp-status') },
      -- Use a fork insteaf because the original plugin was not updated for more than 6 months
      -- { 'glepnir/lspsaga.nvim', config = config('lspsaga'), after = 'nvim-base16' },
      { 'tami5/lspsaga.nvim', config = config('lspsaga'), after = 'nvim-base16' },
      { 'jose-elias-alvarez/null-ls.nvim', config = config('null-ls') },
      { 'camilledejoye/nvim-lsp-selection-range' },
      { 'b0o/schemastore.nvim' }, -- used by jsonls server to retrieve json schemas
      { 'williamboman/nvim-lsp-installer' },
    },
    config = config('lspconfig'),
  }

  use('camilledejoye/php-foldexpr')

  use { -- Phpactor
    'phpactor/phpactor',
    run = 'composer install -o',
    requires = { 'camilledejoye/phpactor-mappings' },
    config = config('phpactor'),
  }

  use { -- Snippets
    -- 'SirVer/ultisnips', -- The engine
    'camilledejoye/ultisnips', branch = 'develop', -- Until the handling of floating windows is fixed
    requires = {
      'honza/vim-snippets', -- The snippets definitions
      { -- PHP snippets
        'sniphpets/sniphpets',
        requires = {
          'sniphpets/sniphpets-common',
          'sniphpets/sniphpets-symfony',
          'sniphpets/sniphpets-phpunit',
          'sniphpets/sniphpets-doctrine',
          'sniphpets/sniphpets-postfix-codes',
        },
        config = function()
          -- Disable because mappings starting with ; causes issues with lsp-signature
          -- The timeout for the mapping resolution make the popup window appears again
          vim.g.sniphpets_common_disable_shortcuts = 1
        end,
      },
    },
    config = function()
      vim.g.UltiSnipsExpandTrigger		= "<Tab>"
      vim.g.UltiSnipsJumpForwardTrigger	= "<C-j>"
      vim.g.UltiSnipsJumpBackwardTrigger	= "<C-k>"
      vim.g.UltiSnipsRemoveSelectModeMappings = 0
    end,
  }

  use { -- Telescope
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    },
    config = config('telescope'),
  }

  use { --fzf-lua
    'ibhagwan/fzf-lua',
    requires = {
      'vijaymarupudi/nvim-fzf',
      { 'kyazdani42/nvim-web-devicons', opt = true },
    },
    config = config('fzf'),
  }

  use { -- lualine
    'hoob3rt/lualine.nvim',
    requires = {
      { 'kyazdani42/nvim-web-devicons', opt = true},
      { 'nvim-lua/lsp-status.nvim', opt = true },
    },
    config = config('lualine'),
  }

  use { -- tpope plugins
    { 'tpope/vim-surround', setup = function() vim.g.surround_no_insert_mappings = true end },
    'tpope/vim-commentary',
    'tpope/vim-scriptease',
    { 'tpope/vim-unimpaired', config = config('unimpaired') },
    'tpope/vim-endwise',
    -- 'tpope/vim-speeddating',
    'tpope/vim-abolish',
    { 'tpope/vim-fugitive', config = config('fugitive') },
    'tpope/vim-repeat',
    'tpope/vim-dispatch',
    'radenling/vim-dispatch-neovim',
    { 'tpope/vim-projectionist', config = config('projectionist') },
    'tpope/vim-eunuch',
    -- 'tpope/vim-sleuth', -- Hopping Treesitter will have good enough defaults
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

  use { -- Trouble
    'folke/trouble.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = config('trouble'),
  }

  use { -- vim-argwrap
    -- 'FooSoft/vim-argwrap',
    'camilledejoye/vim-argwrap', branch = 'imp/php-always-tail-comma-for-method-declaration',
    config = config('vim-argwrap'),
  }

  -- Keep it for reference, I don't work with those languages anymore
  -- use { -- vim-closetag
  --   'alvan/vim-closetag',
  --   config = function()
  --     vim.g.closetag_filetypes = 'html,xhtml,jsx,twig,riot,html.twig'
  --     vim.g.closetag_xhtml_filetypes = 'html,xhtml,jsx,twig,riot,html.twig'
  --   end,
  -- }

  -- I don't use pman doc for php anymore but it could still be interesting for later
  -- use { -- vim-plugin-viewdoc
  --   'powerman/vim-plugin-viewdoc',
  --   config = function ()
  --     vim.opt.keywordprg = [[:ViewDoc <cword>]]
  --     vim.g.no_viewdoc_abbrev = 1 -- Disable abbreviations
  --     vim.g.no_viewdoc_maps = 1 -- Disable mappings
  --     vim.g.viewdoc_open = 'botright vnew' --How to open the help window
  --     vim.g.viewdoc_openempty = 0 -- Do not open window when doc is not found
  --   end
  -- }

  use { -- vim-test
    'rcarriga/vim-ultest',
    run = ":UpdateRemotePlugins" ,
    requires = {"vim-test/vim-test"},
    config = config('vim-test'),
  }

  use { -- lir.nvim
    'tamago324/lir.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'tamago324/lir-bookmark.nvim',
    },
    config = config('lir'),
  }
end, config = {
  disable_commands = true,
}})
