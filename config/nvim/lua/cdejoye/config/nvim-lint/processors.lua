local M = {}

-- Not needed anymore, just like the util.wrap
-- I keep them around in case I want to do another processor which needs the bufnr
-- The wrap I overrode will provide the bufnr to the callback that allows to use this processor first so that
-- my other ones can rely on the bufnr safely
function M.set_bufnr_on_diagnostic(diagnostic, bufnr)
  if not diagnostic.bufnr then
    diagnostic.bufnr = bufnr
  end

  return diagnostic
end

---@param diagnostic vim.Diagnostic
function M.ensure_underline(diagnostic)
   -- underline will only be on first char identified by `diagnostic.col`
   if 0 == diagnostic.col and not diagnostic.end_lnum and not diagnostic.end_col then
     -- will underline the full line identified by `diagnostic.lnum`
     diagnostic.end_lnum = diagnostic.lnum + 1
   end

   return diagnostic
end

local format_diagnostic = require('cdejoye.config.lsp.diagnostic').format;
---Lspsaga doesn't follow vim.lsp.diagnostic.Float.format option
---And we can't define one ourselves
---So I change the message of the diagnostic by applying the format function I use by default
---@param diagnostic vim.Diagnostic
function M.apply_format(diagnostic)
  diagnostic.message = format_diagnostic(diagnostic)

  return diagnostic
end

return M
