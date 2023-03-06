local M = {}

local loaded, selection_range = pcall(require, 'lsp-selection-range')

function M.update_capabilities(capabilities)
  if not loaded then
    return capabilities
  end

  local client = require('lsp-selection-range.client')
  selection_range.setup({
    get_client = client.select_by_filetype(client.select),
  })

  return selection_range.update_capabilities(capabilities)
end

return M
