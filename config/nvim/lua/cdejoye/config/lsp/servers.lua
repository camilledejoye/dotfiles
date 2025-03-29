local M = {}

function M.configuration()
  -- Servers to enable with their specific configuration
  local configuration = {
    intelephense = {
      init_options = { licenceKey = vim.fn.expand('$HOME/.local/share/intelephense/licence-key') },
      settings = {
        intelephense = {
          files = {
            exclude = {
              '**/.git/**',
              '**/.svn/**',
              '**/.hg/**',
              '**/CVS/**',
              '**/.DS_Store/**',
              '**/node_modules/**',
              '**/bower_components/**',
              '**/vendor/**/{Tests,tests}/**',
              '**/.history/**',
              '**/vendor/**/vendor/**',
              -- Symfony project specific
              '**/var/cache/**',
              '**/var/log/**',
            },
          },
        },
      },
    },
    jsonls = {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
        },
      },
    },
    yamlls = {
      settings = {
        yaml = {
          format = {
            singleQuote = true,
            proseWrap = 'Always',
            printWidth = 120, -- TODO detect it for YAML config ?
          },
          schemas = {
            ['https://json.schemastore.org/taskfile.json'] = {
              'Taskfile.dist.yaml',
              '*Taskfile.yaml',
              'tasks/*.yml',
              'tasks/*.yaml',
            },
          },
        },
      },
    },
    lemminx = {}, -- XML
    ts_ls = {},
    lua_ls = {
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
        },
      },
    },
    bashls = {},
    dockerls = {},
    vimls = {},
    cssls = {},
  }

  -- To quickly switch between php servers
  local use_phpactor = false
  if use_phpactor then
    configuration.intelephense = nil
    configuration.phpactor = {
      init_options = { ['language_server_completion.trim_leading_dollar'] = true },
    }
  end

  return configuration
end

function M.setup(on_attach, capabilities)
  for server_name, server_options in pairs(M.configuration()) do
    local options = {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    if 'function' == type(server_options) then
      options = server_options(options)
    elseif 'table' == type(server_options) then
      options = vim.tbl_extend('force', options, server_options)
    end

    require('lspconfig')[server_name].setup(options)
  end

  -- -- Setup null-ls
  -- require('cdejoye.config.lsp.null-ls').setup(on_attach, capabilities)
end

return M
