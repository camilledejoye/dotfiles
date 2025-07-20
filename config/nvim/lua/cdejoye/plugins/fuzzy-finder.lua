local function load_extension_if_available(name)
  local extension_is_installed, _ = pcall(require, 'telescope._extensions.' .. name)
  if extension_is_installed then
    require('telescope').load_extension(name)
  end
end

--- @type LazySpec
return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-telescope/telescope-symbols.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
  },
  opts = function()
    local actions = require('telescope.actions')

    return {
      defaults = {
        prompt_prefix = '❯ ',
        selection_caret = '❯ ',
        sorting_strategy = 'ascending',
        dynamic_preview_title = true,

        mappings = {
          i = {
            ['<C-a>'] = actions.select_all,
            ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
            ['<C-e>'] = actions.results_scrolling_down,
            ['<C-y>'] = actions.results_scrolling_up,

            ['<C-x>'] = false,
            ['<C-s>'] = actions.select_horizontal,
            ['<C-p>'] = 'move_selection_previous',
            ['<C-n>'] = 'move_selection_next',

            -- this is nicer when used with smart-history plugin.
            ['<C-k>'] = actions.cycle_history_next,
            ['<C-j>'] = actions.cycle_history_prev,

            ['<C-space>'] = actions.complete_tag,
          },
          n = {
            ['<C-a>'] = actions.select_all,
            ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
            ['<C-e>'] = actions.results_scrolling_down,
            ['<C-y>'] = actions.results_scrolling_up,
          },
        },
      },

      pickers = {
        buffers = {
          ignore_current_buffer = true,
          selection_strategy = 'closest',
          -- theme = 'ivy',
          mappings = {
            n = {
              ['dd'] = 'delete_buffer',
            },
          },
        },

        grep_string = { layout_strategy = 'vertical' },
        spell_suggest = {
          theme = 'cursor',
          mappings = {
            i = {
              ['<Esc>'] = actions.close,
            },
          },
        },
        lsp_references = { layout_strategy = 'vertical' },
        lsp_definitions = { layout_strategy = 'vertical' },
        lsp_type_definitions = { layout_strategy = 'vertical' },
        lsp_implementations = { layout_strategy = 'vertical' },
      },

      extensions = {
        fzf = {
          fuzzy = true,
          -- To be able to use fzf syntax: !, ', etc
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
        ['ui-select'] = {
          require('telescope.themes').get_dropdown({
            -- even more opts
          }),

          -- pseudo code / specification for writing custom displays, like the one
          -- for "codeactions"
          -- specific_opts = {
            --   [kind] = {
            --     make_indexed = function(items) -> indexed_items, width,
            --     make_displayer = function(widths) -> displayer
            --     make_display = function(displayer) -> function(e)
            --     make_ordinal = function(e) -> string
            --   },
            --   -- for example to disable the custom builtin "codeactions" display
            --      do the following
          --   codeactions = false,
          -- },
        },
      },
    }
  end,
  config = function(_, opts)
    require('telescope').setup(opts)

    load_extension_if_available('fzf')
    load_extension_if_available('luasnip')
    load_extension_if_available('notify')
    load_extension_if_available('ui-select')

    -- Highlights
    local hi = require('cdejoye.utils').hi
    hi('TelescopeBorder', 'FloatBorder')
    hi('TelescopePromptPrefix', 'TSString')
    hi('TelescopeSelectionCaret', 'TSString')

    -- Commands
    vim.cmd(
      [[command! -bang -complete=dir -nargs=* Rg lua require('cdejoye.telescope.pickers').grep_string({ <f-args> }, '!' == '<bang>')]]
    )
    vim.cmd([[command! H lua require('telescope.builtin').help_tags()]])
    vim.cmd([[command! Tplugins lua require('cdejoye.telescope.pickers').find_files_in_plugins()]])
    vim.cmd([[command! Tconfig lua require('cdejoye.telescope.pickers').find_files_in_config()]])

    require('cdejoye.telescope.pickers')
  end,
  cmd = { 'Telescope', 'Rg', 'H', 'Tplugins', 'Tconfig' },
  event = 'VeryLazy', -- replace vim.ui.select so I need it to be loaded before commands and keymaps
  keys = {
    {
      '<Leader>sf',
      function()
        require('cdejoye.telescope.pickers').find_files()
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
}
