return {
  neodev = require('cdejoye.config.lsp.neodev'),
  mason = require('cdejoye.config.lsp.mason'),
  native = require('cdejoye.config.lsp.native'),
  servers = require('cdejoye.config.lsp.servers'),
  on_attach = require('cdejoye.config.lsp.on_attach').on_attach,
  capabilities = require('cdejoye.config.lsp.capabilities').create(),
  diagnostic = require('cdejoye.config.lsp.diagnostic'),
}
