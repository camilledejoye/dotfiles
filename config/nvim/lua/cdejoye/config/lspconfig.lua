local lsp = require('cdejoye.config.lsp')

lsp.native.setup()
lsp.neodev.setup()
lsp.mason.setup()
lsp.servers.setup(lsp.on_attach, lsp.capabilities)
lsp.diagnostic.setup()
