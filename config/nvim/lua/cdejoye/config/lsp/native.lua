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

  -- Define diagnostics signs
  define_sign('LspDiagnosticsSignError', signs.error)
  define_sign('LspDiagnosticsSignWarning', signs.warn)
  define_sign('LspDiagnosticsSignInformation', signs.info)
  define_sign('LspDiagnosticsSignHint', signs.hint)

  -- Define the highlight group for the active parameter in the signature helper
  require('cdejoye.utils').hi('LspSignatureActiveParameter', 'Visual')

  -- Keep trying to load the codelens when opening a file
  vim.api.nvim_create_autocmd('CursorHold', {
    desc = 'vim.lsp.codelens.refresh()',
    callback = function (event)
      vim.lsp.codelens.refresh({ bufnr = event.buf })

      local codelens = vim.lsp.codelens.get(event.buf)

       -- Delete the autocmd once we retrieved the codelens so we don't fetch them
       -- everytime we move the cursor and stop
      return 0 < #codelens
    end,
  })

  -- Retrieve codelens automatically
  vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave' }, {
    desc = 'vim.lsp.codelens.refresh()',
    callback = function (event)
      vim.lsp.codelens.refresh({ bufnr = event.buf })
    end,
  })

  vim.lsp.commands['editor.action.peekLocations'] = function (cmd, ctx)
    dump(cmd, ctx, 'TODO: run codelens')
    -- might want to implement something to adapt results to qlist or clist
    -- then leverage telescope or trouble to show it ?
  end
end

return M
