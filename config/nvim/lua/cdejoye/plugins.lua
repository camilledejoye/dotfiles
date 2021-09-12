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
  use { -- Packer can manage itself
    'wbthomason/packer.nvim',
    cmd = { 'PackerInstall', 'PackerUpdate', 'PackerSync', 'PackerClean', 'PackerCompile' },
  }

  use { -- Miscelanous
    'camilledejoye/vim-cleanfold',
    'kana/vim-niceblock',
    'terryma/vim-multiple-cursors',
    'junegunn/vader.vim',
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

  -- TODO check if I still need it now that I use Treesitter
  use('wellle/targets.vim') -- Adds a bunch of text objects, especially argument text object

  use { -- Fix CursorHold performance issue on Neovim:
    -- https://github.com/antoinemadec/FixCursorHold.nvim
    -- See: https://github.com/neovim/neovim/issues/12587
    "antoinemadec/FixCursorHold.nvim",
    run = [[vim.g.curshold_updatime = 1000]]
  }

  use { -- Add documentation around Lua
    'nanotee/luv-vimdocs',
    'milisims/nvim-luaref',
  }

  use { 'kyazdani42/nvim-web-devicons' }

  use('monaqa/dial.nvim') -- Improved increment/decrement
  use('tommcdo/vim-lion') -- Align text

  use { 'w0rp/ale', config = config('ale') }

  use { 'jiangmiao/auto-pairs', config = config('auto-pairs') }

  use { -- Colorizer
    'norcalli/nvim-colorizer.lua',
    setup = [[require('cdejoye.utils').map('yoC', '<cmd>ColorizerToggle<CR>')]],
    cmd = 'ColorizerToggle',
  }

  use { 'RRethy/nvim-base16', config = config('colorscheme') }

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

  use { -- EditorConfig
    'editorconfig/editorconfig-vim',
    config = function()
      vim.g.EditorConfig_exclude_patterns = {'fugitive://.\\*'}
      vim.g.EditorConfig_disable_rules = {'trim_trailing_whitespace'}
    end,
  }

  use { -- GitSigns
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = config('gitsigns'),
  }

  use{ 'rhysd/git-messenger.vim', config = config('git-messenger') }

  use { -- Neorg
    'vhyrro/neorg',
    branch = 'unstable',
    requires = { 'nvim-lua/plenary.nvim', 'vhyrro/neorg-telescope' },
    after = 'nvim-treesitter',
    config = config('neorg'),
  }

  use {
    'L3MON4D3/LuaSnip',
    -- requires = { 'rafamadriz/friendly-snippets' },
    config = config('luasnip'),
  }

  use { -- Completion manager
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'onsails/lspkind-nvim',
      'hrsh7th/cmp-nvim-lsp',
      'ray-x/lsp_signature.nvim',
      -- Disable while I'm still using UltiSnips (no need for LSP)
      -- 'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
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
      { 'glepnir/lspsaga.nvim', config = config('lspsaga'), after = 'nvim-base16' },
    },
    config = config('lspconfig'),
  }

  -- TODO test it to make sure it's correctly configured
  -- require('cdejoye.diagnosticls')

  use('camilledejoye/php-foldexpr')

  use { -- Phpactor
    'phpactor/phpactor',
    run = 'composer install -o',
    requires = { 'camilledejoye/phpactor-mappings' },
    config = config('phpactor'),
  }

  use { -- Snippets
    'SirVer/ultisnips', -- The engine
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
    -- 'tpope/vim-endwise',
    -- 'tpope/vim-speeddating',
    'tpope/vim-abolish',
    -- Lua alternative to check: https://github.com/TimUntersberger/neogit
    { 'tpope/vim-fugitive', config = config('fugitive') },
    'tpope/vim-repeat',
    'tpope/vim-dispatch',
    'radenling/vim-dispatch-neovim',
    { 'tpope/vim-projectionist', config = config('projectionist') },
    'tpope/vim-eunuch',
    'tpope/vim-sleuth',
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
    lock = true, -- Waiting for https://github.com/folke/trouble.nvim/issues/86
  }

  use { -- vim-argwrap
    'FooSoft/vim-argwrap',
    config = config('vim-argwrap'),
  }

  use { -- vim-closetag
    'alvan/vim-closetag',
    config = function()
      vim.g.closetag_filetypes = 'html,xhtml,jsx,twig,riot,html.twig'
      vim.g.closetag_xhtml_filetypes = 'html,xhtml,jsx,twig,riot,html.twig'
    end,
  }

  use { -- vim-plugin-viewdoc
    'powerman/vim-plugin-viewdoc',
    config = function ()
      vim.opt.keywordprg = [[:ViewDoc <cword>]]
      vim.g.no_viewdoc_abbrev = 1 -- Disable abbreviations
      vim.g.no_viewdoc_maps = 1 -- Disable mappings
      vim.g.viewdoc_open = 'botright vnew' --How to open the help window
      vim.g.viewdoc_openempty = 0 -- Do not open window when doc is not found
    end
  }

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

  -- TODO: check these plugins
  -- https://github.com/lukas-reineke/indent-blankline.nvim
  -- To add floating signature when typing: https://github.com/ray-x/lsp_signature.nvim
  -- Add info from LSP to status bar: https://github.com/nvim-lua/lsp-status.nvim
    -- Example config: https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/lsp/status.lua
  -- https://github.com/ms-jpq/coq_nvim (completion supposed to be fast)
  -- https://github.com/folke/zen-mode.nvim
  -- https://github.com/folke/twilight.nvim
end, config = {
  disable_commands = true,
}})
