return {
  { 'onsails/lspkind-nvim', event = 'InsertEnter', config = true },
  { 'williamboman/mason.nvim', event = 'VeryLazy' },
  { 'williamboman/mason-lspconfig.nvim', event = 'VeryLazy' },
  { 'jayp0521/mason-nvim-dap.nvim', event = 'VeryLazy' },
  require('cdejoye.plugins.lsp.lua'),
  require('cdejoye.plugins.lsp.signature'),
  require('cdejoye.plugins.lsp.lspsaga'),
  { 'camilledejoye/nvim-lsp-selection-range', event = 'LspAttach' },
  { 'mfussenegger/nvim-jdtls', ft = 'java' },
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    config = function()
      -- That's where I load everything related to LSP, and make sure it's in the right order
      -- Servers config, Mason, Mason extensions, etc.
      require('cdejoye.config.lspconfig')
    end,
  },
}
