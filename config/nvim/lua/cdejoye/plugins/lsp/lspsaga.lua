--- @module lazy
--- @type LazySpec
return {
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
    },
  },
}
