local M = {}

function M.setup()
  if pcall(require, 'neodev') then
    -- Must be setup before lspconfig
    require('neodev').setup({
      library = {
        plugins = { 'neotest', 'nvim-dap-ui', 'nvim-lspconfig' },
      },
    })
  end
end

return M
