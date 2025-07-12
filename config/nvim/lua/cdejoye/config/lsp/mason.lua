local M = {}

local icons = require('cdejoye.icons')

local function install_pylsp_extensions()
  local pylsp = require('mason-registry').get_package('python-lsp-server')
  pylsp:on('install:success', function()
    local function mason_package_path(package)
      local path = vim.fn.resolve(vim.fn.stdpath('data') .. '/mason/packages/' .. package)
      return path
    end

    local path = mason_package_path('python-lsp-server')
    local command = path .. '/venv/bin/pip'
    local args = {
      'install',
      '-U',
      'pylsp-rope',
      'python-lsp-black',
      'python-lsp-isort',
      'python-lsp-ruff',
      'pyls-memestra',
      'pylsp-mypy',
    }

    require('plenary.job')
      :new({
        command = command,
        args = args,
        cwd = path,
      })
      :start()
  end)
end

function M.setup()
  local mason = require('mason')
  mason.setup({
    ui = {
      icons = {
        package_installed = icons.check.default,
        package_pending = icons.arrow.thick,
        package_uninstalled = icons.uncheck.thick,
      },
    },
  })

  install_pylsp_extensions()

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

  -- Automatically update when the plugin is loaded
  vim.api.nvim_command('MasonUpdate')
end

return M
