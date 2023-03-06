local M = {
  on_attach = function() end,
}

local loaded, lsp_signature = pcall(require, 'lsp_signature')
if loaded then
  M.on_attach = function(_, bufnr)
    lsp_signature.on_attach({
      hi_parameter = 'Visual',
      -- padding = ' ', -- Generate an error when using the toggle key to show the signature
      floating_window_above_cur_line = true,
      handler_opts = {
        border = 'single', -- double, rounded, single, shadow, none
      },
      hint_enable = false, -- Disable virtual text
      toggle_key = '<C-s>',
    }, bufnr)
  end
end

return M
