local function config(name)
  local cmd = [[cdejoye.config.%s]]

  return function()
    require(cmd:format(name))
  end
end

local function formatter(name)
  return function()
    local exists, opts = pcall(require, 'cdejoye.conform.formatters.' .. name)

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
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- A high number is recommended for colorscheme
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000,
  },
  {
    'navarasu/onedark.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('onedark').setup({
        style = 'darker',
        highlights = {
          WinBar = { bg = 'none' },
          WinBarNC = { bg = 'none' },
        },
      })
      -- Enable theme
      require('onedark').load()
    end,
  },

  -- Miscelanous
  'camilledejoye/vim-cleanfold',

  {
    'jake-stewart/multicursor.nvim',
    config = function()
      local mc = require('multicursor-nvim')
      mc.setup()

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- Select a different cursor as the main one.
        layerSet({ 'n', 'x' }, '<left>', mc.prevCursor)
        layerSet({ 'n', 'x' }, '<right>', mc.nextCursor)

        -- Select and jump to the next match
        layerSet({ 'v', 'x' }, '<C-p>', function()
          mc.matchAddCursor(-1)
        end)
        layerSet({ 'v', 'x' }, '<C-s>', function()
          mc.matchSkipCursor(1)
        end)
        -- Delete the main cursor.
        layerSet({ 'v', 'x' }, '<C-x>', mc.deleteCursor)

        -- Enable and clear cursors using escape.
        layerSet('n', '<esc>', function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)
    end,
    keys = {
      {
        '<C-n>',
        function()
          vim.cmd.normal('viw')
          require('multicursor-nvim').matchAddCursor(1)
        end,
        mode = 'n',
        desc = 'Start multi-cursor for the word under the cursor',
      },
      {
        '<C-n>',
        function()
          require('multicursor-nvim').matchAddCursor(1)
        end,
        mode = 'x',
        desc = 'Add current selection to the list of cursors and jump to the next match',
      },
    },
  },

  {
    'chrisgrieser/nvim-puppeteer',
    lazy = false, -- plugin lazy-loads itself. Can also load on filetypes.
  },

  { -- markdown-preview
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
    ft = { 'markdown' },
  },

  'wellle/targets.vim', -- Adds a bunch of text objects, especially argument text object

  -- Add documentation around Lua
  'milisims/nvim-luaref',

  'nvim-tree/nvim-web-devicons',

  { -- Improved increment/decrement
    'monaqa/dial.nvim',
    keys = {
      {
        '<C-a>',
        '<Plug>(dial-increment)',
        mode = { 'n', 'v' },
        desc = 'Increment with dial.nvim',
      },
      {
        '<C-x>',
        '<Plug>(dial-decrement)',
        mode = { 'n', 'v' },
        desc = 'Increment with dial.nvim',
      },
    },
  },

  {
    'echasnovski/mini.align',
    version = false,
    opts = {
      mappings = {
        start = 'gl',
        start_with_preview = 'gL',
      },
    },
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    -- Use config to only load custom rules when the plugin is loaded
    config = config('autopairs'),
  },

  { -- Colorizer
    'norcalli/nvim-colorizer.lua',
    keys = {
      { 'yoC', '<cmd>ColorizerToggle<CR>', desc = 'Toggle nvim-colorizer.lua' },
    },
    cmd = 'ColorizerToggle',
  },

  { -- Telescope
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-symbols.nvim',
    },
    config = config('telescope'),
    cmd = { 'Telescope', 'Rg', 'Tplugins', 'Tconfig' },
    keys = {
      {
        '<Leader>sf',
        function()
          require('cdejoye.config.telescope').find_files()
        end,
        desc = 'Find files, using Git if possible',
      },
      {
        '<Leader>sF',
        function()
          require('telescope.builtin').find_files({ no_ignore = true, hidden = true })
        end,
        desc = 'Find files, including ignored and hidden files',
      },
      {
        '<Leader>sb',
        function()
          require('telescope.builtin').buffers()
        end,
        desc = 'List buffers',
      },
      {
        '<Leader>sgc',
        function()
          require('telescope.builtin').git_commits()
        end,
        desc = 'List Git commits',
      },
      {
        '<Leader>sgC',
        function()
          require('telescope.builtin').git_bcommits()
        end,
        desc = 'List commits containing the current buffer',
      },
      {
        '<Leader>sgb',
        function()
          require('telescope.builtin').git_branches()
        end,
        desc = 'List Git branches',
      },
      {
        '<Leader>sgs',
        function()
          require('telescope.builtin').git_status()
        end,
        desc = 'Show Git status',
      },
      {
        '<Leader>sm',
        function()
          require('telescope.builtin').lsp_document_symbols({ symbols = { 'method' } })
        end,
        desc = '[LSP] List methods in the current buffer',
      },
      { '<Leader>rg', [[<cmd>Rg<CR>]], desc = 'Grep the word under the cursor' },
      {
        '<Leader>Rg',
        [[<cmd>Rg!<CR>]],
        desc = 'Grep the word under the cursor, including ignore and hidden files',
      },
      { '<Leader>H', [[<cmd>H<CR>]], desc = 'List help tags' },
      {
        'z=',
        function()
          require('telescope.builtin').spell_suggest()
        end,
        desc = 'Show spell suggestions for the spelling error under the cursor',
      },
    },
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
    },
    config = config('dap'),
    keys = {
      {
        '<Leader>dc',
        function()
          require('dap').continue()
        end,
        desc = 'Start/Resume a debugging session',
      },
      {
        '<Leader>ds',
        function()
          require('dap').terminate()
          require('dapui').close()
        end,
        desc = 'Close a debugging session',
      },
      {
        '<Leader>dd',
        function()
          require('dap').step_over()
        end,
        desc = 'Step over the current instruction',
      },
      {
        '<Leader>di',
        function()
          require('dap').step_into()
        end,
        desc = 'Step into the current instruction',
      },
      {
        '<Leader>do',
        function()
          require('dap').step_out()
        end,
        desc = 'Step out to the parent instruction',
      },
      {
        '<Leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Toggle breakpoint',
      },
      {
        '<Leader>dB',
        function()
          vim.ui.input({ prompt = 'Breakpoint condition: ' }, function(input)
            require('dap').set_breakpoint(input)
          end)
        end,
        desc = 'Toggle breakpoint with condition',
      },
      {
        '<Leader>dr',
        function()
          require('dap').repl.open()
        end,
        desc = 'Open a REPL',
      },
      {
        '<Leader>de',
        function()
          require('dapui').eval()
        end,
        mode = { 'n', 'v' },
        desc = 'Evaluate the current word or selection and show the results in a floating window',
      },
    },
  },

  { -- GitSigns
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      watch_gitdir = {
        interval = 250,
        follow_files = true,
      },

      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local bmap = function(mode, lsh, rsh, opts)
          require('cdejoye.utils').bmap(bufnr, lsh, rsh, mode, opts)
        end

        -- Navigation
        bmap('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            gs.nav_hunk('next')
          end
        end)

        bmap('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            gs.nav_hunk('prev')
          end
        end)

        -- Actions
        bmap('n', '<leader>sh', gs.stage_hunk)
        bmap('v', '<leader>sh', function()
          gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)
        bmap('n', '<leader>uh', gs.reset_hunk)
        bmap('v', '<leader>uh', function()
          gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)
        bmap('n', '<leader>Rh', gs.reset_buffer)
        bmap('n', '<leader>ph', gs.preview_hunk)
        bmap('n', '<leader>bh', function()
          gs.blame_line({ full = true })
        end)
        bmap('n', '<leader>Sh', gs.stage_buffer)
        bmap('n', '<leader>Uh', gs.reset_buffer_index)

        bmap('n', '<leader>hu', gs.undo_stage_hunk)
        bmap('n', '<leader>Uh', gs.reset_buffer_index)
        bmap('n', '<leader>tb', gs.toggle_current_line_blame)
        bmap('n', '<leader>hd', gs.diffthis)
        bmap('n', '<leader>hD', function()
          gs.diffthis('~')
        end)
        bmap('n', '<leader>td', gs.toggle_deleted)

        -- Text object
        bmap('ox', 'ih', gs.select_hunk)
      end,
    },
  },

  { -- neogit
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
  },

  { -- diffview
    'sindrets/diffview.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    config = config('diffview'),
    cmd = {
      'DiffviewOpen',
      'DiffviewFileHistory',
      'DiffviewLog',
      'DiffviewClose',
      'DiffviewRefresh',
      'DiffviewFocusFiles',
      'DiffviewToggleFiles',
    },
  },

  {
    'rhysd/git-messenger.vim',
    init = function()
      vim.g.git_messenger_no_default_mappings = false
      vim.g.git_messenger_floating_win_opts = { border = 'rounded' }
      vim.g.git_messenger_popup_content_margins = false
      vim.g.git_messenger_extra_blame_args = '-w'

      function setup_mappings()
        local bmap = function(...)
          require('cdejoye.utils').bmap(vim.api.nvim_get_current_buf(), ...)
        end
        local opts = { noremap = false }

        bmap('<C-o>', 'o', 'n', opts)
        bmap('<C-i>', 'O', 'n', opts)
      end

      vim.cmd([[
      augroup cdejoye_git_messenger
      autocmd!
      autocmd FileType gitmessengerpopup lua setup_mappings()
      augroup END
      ]])
    end,
    cmd = { 'GitMessenger' },
    keys = {
      { '<Leader>gm', '<Plug>(git-messenger)' },
    },
  },

  { 'vhyrro/luarocks.nvim', priority = 1000, config = true },

  { -- Neorg
    'nvim-neorg/neorg',
    dependencies = {
      'vhyrro/luarocks.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neorg/neorg-telescope',
    },
    -- Lazy loading can cause issues, uncomment this to debug in case of trouble
    -- lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = '*', -- Pin Neorg to the latest stable release
    config = config('neorg'),
    ft = 'norg',
  },

  {
    'L3MON4D3/LuaSnip',
    build = 'make install_jsregexp',
    event = 'InsertEnter',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'benfowler/telescope-luasnip.nvim',
    },
    config = config('luasnip'),
  },

  {
    'onsails/lspkind-nvim',
    event = 'InsertEnter',
    config = true,
  },

  { -- Completion manager
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
      'hrsh7th/cmp-emoji',
      'chrisgrieser/cmp-nerdfont',
      'f3fora/cmp-spell',
    },
    config = config('cmp'),
    event = { 'InsertEnter', 'CmdlineEnter' },
    priority = 100, -- default priority is 50 and this must be loaded before nvim-lspconfig to add cmp capabilities
  },

  -- LSP
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  { -- 3rd party installer
    'williamboman/mason.nvim',
    event = 'VeryLazy',
  },
  {
    'williamboman/mason-lspconfig.nvim',
    event = 'VeryLazy',
  },
  {
    'jayp0521/mason-nvim-dap.nvim',
    event = 'VeryLazy',
  },
  -- 'jayp0521/mason-null-ls.nvim',
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    config = config('lspconfig'),
  },
  {
    'ray-x/lsp_signature.nvim',
    event = 'InsertEnter',
    opts = {
      hi_parameter = 'Visual',
      -- padding = ' ', -- Generate an error when using the toggle key to show the signature
      floating_window_above_cur_line = true,
      handler_opts = {
        border = 'single', -- double, rounded, single, shadow, none
      },
      hint_enable = false, -- Disable virtual text
      toggle_key = '<C-s>',
    },
  },
  {
    'nvimdev/lspsaga.nvim',
    event = 'LspAttach',
    opts = {
      code_action = {
        show_server_name = true,
        extend_gitsigns = true,
        keys = {
          quit = { 'q', '<Esc>' },
        },
      },
      code_action_lightbulb = {
        sign = false,
      },
      symbol_in_winbar = {
        enable = true,
        show_file = false,
      },
    },
    keys = {
      {
        'gH',
        '<cmd>Lspsaga peek_definition<CR>',
        desc = 'Peek at the definition of the symbol under the cursor',
      },
      {
        '<Leader><Leader>',
        '<cmd>Lspsaga term_toggle<CR>',
        desc = 'Open a temporary terminal in a floating window',
      }
    },
  },

  -- -- Keep it close in case of issue to be able to quickly go back to a working state
  -- 'jose-elias-alvarez/null-ls.nvim',
  {
    'stevearc/conform.nvim',
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<Leader>ff',
        function()
          require('conform').format({ async = true })
        end,
        mode = '',
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
        lsp_format = 'fallback',
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
  {
    'zapling/mason-conform.nvim',
    event = 'VeryLazy',
    opts = {
      -- Usually installed per project to have specific versions
      ignore_install = { 'phpcbf', 'phpcs', 'phpstan', 'php_cs_fixer' },
    },
  },
  {
    'mfussenegger/nvim-lint',
    event = 'VeryLazy',
    config = config('nvim-lint'),
  },
  {
    'rshkarin/mason-nvim-lint',
    event = 'VeryLazy',
    opts = {
      -- Usually installed per project to have specific versions
      ignore_install = { 'phpstan', 'php_cs_fixer', 'phpcs' },
    },
  },
  { 'camilledejoye/nvim-lsp-selection-range', event = 'LspAttach' },
  { 'b0o/schemastore.nvim', event = 'VeryLazy' }, -- used by jsonls server to retrieve json schemas
  { 'mfussenegger/nvim-jdtls', ft = 'java' },

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
      {
        'camilledejoye/phpactor-mappings',
        init = function()
          -- Enable while experimental
          vim.g.phpactorInputListStrategy = 'phpactor#input#list#fzf'
          vim.g.phpactorQuickfixStrategy = 'phpactor#quickfix#fzf'

          -- phpactor-mapping
          vim.g.phpactorActivateOverlapingMappings = true
        end,
      },
      'junegunn/fzf.vim',
      { 'junegunn/fzf', build = ':call fzf#install()' },
    },
    ft = 'php',
    keys = {
      {
        '<Leader>pp',
        '<Plug>phpactorContextMenu',
        desc = '[Phpactor] Open context menu',
      },
      {
        '<Leader>pt',
        '<Plug>phpactorTransform',
        desc = '[Phpactor] Open transformation menu',
      },
      {
        '<Leader>pe',
        '<Plug>phpactorClassExpand',
        desc = '[Phpactor] Expand the class name, under the curor, as a FQCN',
      },
    },
  },

  {
    'camilledejoye/vim-php-refactoring-toolbox',
    branch = 'improvements',
    init = function()
      vim.g.vim_php_refactoring_use_default_mapping = 0
    end,
    ft = 'php',
    keys = {
      { '<Leader>pi', [[<cmd>call PhpInline()<CR>]] },
    },
  },

  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
      input = { enabled = true, win = { relative = 'cursor' } },
    },
  },

  { -- lualine
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = config('lualine'),
  },

  { -- tpope plugins
    {
      'tpope/vim-surround',
      setup = function()
        vim.g.surround_no_insert_mappings = true
      end,
    },
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

  {
    'folke/ts-comments.nvim',
    opts = {},
    event = 'VeryLazy',
    enabled = vim.fn.has('nvim-0.10.0') == 1,
  },

  { -- Treesitter
    -- TODO to auto close tags check: https://github.com/windwp/nvim-ts-autotag
    'nvim-treesitter/nvim-treesitter',
    branch = 'master', -- Make sure to specify the master branch, as the default branch will switch to main in the future
    lazy = false, -- does not support lazy-loading
    build = ':TSUpdate',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' },
    },
    config = config('nvim-treesitter'),
  },

  {
    'https://git.sr.ht/~foosoft/argonaut.nvim',
    opts = {
      comma_last = true,
      limit_cols = 512,
      limit_rows = 64,
      by_filetype = {
        json = { comma_last = false },
      },
    },
    cmd = { 'ArgonautToggle' },
    keys = {
      {
        'gaw',
        ':<C-u>ArgonautToggle<CR>',
        desc = 'Wrap/UnWrap arguments',
        noremap = true,
        silent = true,
      },
    },
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
    'vim-test/vim-test',
    init = function()
      -- Disabled the possibility to run a test from it's source file
      -- g['test#no_alternate'] = 1 " Ex.: Don't run tests on save from the sources
      vim.g['test#php#behat#use_suite_in_args'] = 1
      -- For Worldia because we don't have a file matching the default glob pattern:
      -- features/bootstrap/**/*.php
      vim.g['test#php#behat#bootstrap_directory'] = '*'
      vim.g['test#php#behat#nearest_use_exact_regex'] = 1

      -- Don't run *Test.php with codeception
      vim.g['test#php#codeception#file_pattern'] = [[\v((c|C)e(p|s)t\.php$|\.feature$)]]

      -- Ignore data provider which have to be public methods too
      vim.g['test#php#phpunit#patterns'] = {
        test = {
          [[\v^\s*public function (test\w+)\(]],
          [[\v^\s*\*\s*(\@test)]],
        },
        namespace = {},
      }
      -- If `phpunit` is in the PATH (custom script) then use this instead
      if vim.fn.executable('phpunit') then
        vim.g['test#php#phpunit#executable'] = 'phpunit'
      end
      -- g['test#php#phpunit#options'] = '--testdox' -- Use testdox format for PHPUnit

      -- If `phpspec` is in the PATH (custom script) then use this instead
      if vim.fn.executable('phpspec') then
        vim.g['test#php#phpspec#executable'] = 'phpspec'
      end
      vim.g['test#php#phpspec#options'] = {
        nearest = '--format=pretty --verbose',
        all = '--format=pretty',
        suite = '--format=progress',
      }

      -- If `behat` is in the PATH (custom script) then use this instead
      if vim.fn.executable('behat') then
        vim.g['test#php#behat#executable'] = 'behat'
      end

      vim.g['test#strategy'] = 'neovim'
      vim.g.ultest_loaded = 1
    end,
    keys = {
      { '<Leader>tf', '<cmd>TestFile<CR>' },
      { '<Leader>tn', '<cmd>TestNearest<CR>' },
      { '<Leader>ts', '<cmd>TestSuite<CR>' },
      { '<Leader>tl', '<cmd>TestLast<CR>' },
      { '<Leader>tv', '<cmd>TestVisit<CR>' },
    },
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
      'nvim-tree/nvim-web-devicons',
      'tamago324/lir-bookmark.nvim',
    },
    config = config('lir'),
    keys = {
      {
        '-',
        [[:edit <C-r>=expand('%:p:h')<CR><CR>]],
        desc = 'Open folder of current file in current buffer',
        noremap = false,
        silent = true,
      },
    },
  },

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

  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    config = true,
    opts = {
      -- Terminal configuration
      terminal = {
        provider = 'native',
      },
    },
    keys = {
      { '<leader>a', nil, desc = 'AI/Claude Code' },
      { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
      { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
      { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
      {
        '<leader>as',
        '<cmd>ClaudeCodeTreeAdd<cr>',
        desc = 'Add file',
        ft = { 'NvimTree', 'neo-tree', 'oil' },
      },
      -- Diff management
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
    },
  },
}, {
  dev = {
    path = '~/work/nvim-plugins',
  },
})
