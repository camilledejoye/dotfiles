local M = {}

-- To quickly switch between php servers
local should_use_phpactor = true

local servers = {}
local function install(name, options)
  servers[name] = false
  vim.lsp.config(name, options or {})
end

local function enable(name, options)
  install(name, options)
  servers[name] = true
end

local function register_servers()
  install('phpactor')
  install('intelephense')
  enable(should_use_phpactor and 'phpactor' or 'intelephense')

  enable('jsonls')
  enable('yamlls')
  enable('lemminx') -- XML
  enable('ts_ls')
  enable('lua_ls')
  enable('bashls')
  enable('dockerls')
  enable('vimls')
  enable('cssls')
  -- enable('jdtls') -- Java
  enable('pylsp')
end

local function install_servers()
  local servers_to_install = {}
  local servers_to_not_enable = {}
  for name, is_enable in pairs(servers) do
    table.insert(servers_to_install, name)
    if not is_enable then
      table.insert(servers_to_not_enable, name)
    end
  end

  -- Keep mason-lspconfig to install and enable the servers
  -- It comes with the ability to map server name between Mason and lspconfig (they can differ)
  -- Additionally, it also handles hooks to enable a server after it's installed
  -- Since Mason install aynchronously, if I try to manully enable a server with vim.lsp.enable() it won't
  -- work until I restart nvim (on first install)
  require('mason-lspconfig').setup({
    ensure_installed = servers_to_install,
    automatic_enable = {
      exclude = servers_to_not_enable,
    },
  })
end

function M.setup()
  register_servers()
  install_servers()
end

return M
