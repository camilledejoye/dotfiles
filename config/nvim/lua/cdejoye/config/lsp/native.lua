local M = {}

function M.setup()
  -- -- Set debug log level
  -- vim.lsp.set_log_level('debug')

  -- Disable diagnostics virtual text
  vim.diagnostic.config({ virtual_text = false })

  -- Define diagnostics signs
  vim.cmd([[
sign define LspDiagnosticsSignError text=
sign define LspDiagnosticsSignWarning text=
sign define LspDiagnosticsSignInformation text=
sign define LspDiagnosticsSignHint text=
]])

  -- Define the highlight group for the active parameter in the signature helper
  require('cdejoye.utils').hi('LspSignatureActiveParameter', 'Visual')
end

return M
