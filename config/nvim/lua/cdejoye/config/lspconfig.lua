local lsp = require('cdejoye.config.lsp')

vim.lsp.config('*', {
  on_attach = lsp.on_attach,
  capabilities = lsp.capabilities,
})

lsp.native.setup()
lsp.neodev.setup()
lsp.mason.setup()
lsp.servers.setup()
lsp.diagnostic.setup()
