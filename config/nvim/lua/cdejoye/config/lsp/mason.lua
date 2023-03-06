local M = {}

function M.setup()
  require('mason').setup({
    ui = {
      icons = {
        package_installed = '✓',
        package_pending = '➜',
        package_uninstalled = '✗',
      },
    },
  })

  require('mason-lspconfig').setup({
    ensure_installed = { 'phpactor' },
    automatic_installation = true,
  })

  require('mason-nvim-dap').setup({
    ensure_installed = { 'php' },
    automatic_setup = true,
  })
  require('mason-nvim-dap').setup_handlers({
    function(source_name)
      -- all sources with no handler get passed here

      -- Keep original functionality of `automatic_setup = true`
      require('mason-nvim-dap.automatic_setup')(source_name)
    end,
    php = function()
      -- Configuration found in:
      -- https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/adapters.lua
      require('dap').adapters.php = require('mason-nvim-dap.mappings.adapters').php

      local default_config = require('mason-nvim-dap.mappings.configurations').php
      require('dap').configurations.php = vim.tbl_deep_extend('force', default_config, {
        {
          port = 9003,
          pathMappings = {
            ['/var/www/html'] = '${workspaceFolder}',
          },
        },
      })
    end,
  })
end

return M
