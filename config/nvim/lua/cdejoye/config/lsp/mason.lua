local M = {}

local icons = require('cdejoye.icons')

function M.setup()
  require('mason').setup({
    ui = {
      icons = {
        package_installed = icons.check.default,
        package_pending = icons.arrow.thick,
        package_uninstalled = icons.uncheck.thick,
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
    handlers = {
      function(config)
        -- all sources with no handler get passed here

        -- Keep original functionality
        require('mason-nvim-dap').default_setup(config)
      end,
      php = function(config)
        config.configurations = vim.tbl_deep_extend('force', config.configurations, {
          {
            port = 9003,
            pathMappings = {
              ['/var/www/html'] = '${workspaceFolder}',
            },
          },
        })

        require('mason-nvim-dap').default_setup(config) -- don't forget this!
      end,
    },
  })
end

return M
