local M = {}

local cmp_lsp_loaded, cmp_lsp = pcall(require, 'cmp_nvim_lsp')

function M.create()
  -- Setup the default client capabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- nvim-cmp supports additional completion capabilities
  if cmp_lsp_loaded then
    capabilities = vim.tbl_deep_extend('force', capabilities, cmp_lsp.default_capabilities())
  end

  return require('cdejoye.config.lsp.selection-range').update_capabilities(capabilities)
end

return M
