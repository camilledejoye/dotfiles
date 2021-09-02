-- https://github.com/sumneko/lua-language-server
-- TODO script the install of the server is not existing ?
-- Example here:
-- https://github.com/tjdevries/nlua.nvim/blob/master/scripts/download_sumneko.lua
local sumneko_root_path = vim.fn.getenv 'HOME' .. '/lsp/server/lua-language-server'
local sumneko_binary = sumneko_root_path .. '/bin/Linux/lua-language-server'

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

local M = {}

function M.setup(on_attach, capabilities)
  require('lspconfig').sumneko_lua.setup {
    cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file('', true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }
end

return M
