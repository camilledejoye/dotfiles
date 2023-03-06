local M = {}

local signs = require('cdejoye.icons').diagnostics

local function define_sign(name, text)
  vim.cmd(('sign define %s text=%s'):format(name, text))

  local base_name = name:gsub('^LspDiagnostics', 'Diagnostic')
  vim.cmd(('sign define %s text=%s texthl=%s'):format(base_name, text, base_name))
end

function M.setup()
  -- -- Set debug log level
  -- vim.lsp.set_log_level('debug')

  -- Disable diagnostics virtual text
  vim.diagnostic.config({ virtual_text = false })

  -- Define diagnostics signs
  define_sign('LspDiagnosticsSignError', signs.error)
  define_sign('LspDiagnosticsSignWarning', signs.warn)
  define_sign('LspDiagnosticsSignInformation', signs.info)
  define_sign('LspDiagnosticsSignHint', signs.hint)

  -- Define the highlight group for the active parameter in the signature helper
  require('cdejoye.utils').hi('LspSignatureActiveParameter', 'Visual')
end

return M
