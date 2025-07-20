--- @module lazy
--- @type LazySpec
return {
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
}
