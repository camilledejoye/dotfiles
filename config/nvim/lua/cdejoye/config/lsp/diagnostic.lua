local M = {}

 function M.format(diagnostic)
  if diagnostic.source then
    return ('%s [%s]'):format(diagnostic.message, diagnostic.source)
  end

  return diagnostic.message
end

function M.setup()
  vim.diagnostic.config({
    -- Disable diagnostics virtual text
    virtual_text = false,
    float = { format = M.format }
  })
end

return M
