-- vim.lsp.set_log_level('debug')
-- LSP settings
local lsp_signature = require('lsp_signature')
local lsp_installer = require('nvim-lsp-installer')
local lsp_selection_range = require('lsp-selection-range')
local lsr_client = require('lsp-selection-range.client')
local hi = require('cdejoye.utils').hi

lsp_selection_range.setup({
  get_client = lsr_client.select_by_filetype(lsr_client.select)
})

-- Define diagnostics signs
vim.cmd([[
sign define LspDiagnosticsSignError text=
sign define LspDiagnosticsSignWarning text=
sign define LspDiagnosticsSignInformation text=🛈
sign define LspDiagnosticsSignHint text=
]])

-- Define the highlight group for the active parameter in the signature helper
hi('LspSignatureActiveParameter', 'Visual')

-- Disable diagnostics virtual text
vim.diagnostic.config({virtual_text = false})

-- To quickly switch between php servers
local use_phpactor = false

-- Servers to enable with their specific configuration
local servers_options = {
  intelephense = {
    init_options = { licenceKey = vim.fn.expand('$HOME/.local/share/intelephense/licence-key') },
    settings = {
      intelephense = {
        files = {
          exclude = {
            "**/.git/**",
            "**/.svn/**",
            "**/.hg/**",
            "**/CVS/**",
            "**/.DS_Store/**",
            "**/node_modules/**",
            "**/bower_components/**",
            "**/vendor/**/{Tests,tests}/**",
            "**/.history/**",
            "**/vendor/**/vendor/**",
            -- Symfony project specific
            "**/var/cache/**",
            "**/var/log/**",
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
      },
    },
  },
  lemminx = {}, -- XML
  tsserver = {},
  sumneko_lua = require('lua-dev').setup(),
}

-- -- Uncomment to install/update all pre-configured servers when start Neovim
-- local settings = require('nvim-lsp-installer.settings')
-- local JobExecutionPool = require('nvim-lsp-installer.jobs.pool')
-- -- Limit the number of server installed at the same time to limit the resource consumption
-- local job_pool = JobExecutionPool:new({
--   size = settings.current.max_concurrent_installers,
-- })
-- for server_name, _ in pairs(servers_options) do
--   local log_levels = vim.log.levels
--   local server_was_found, server = lsp_installer.get_server(server_name)
--   if server_was_found and not server:is_installed() then
--     local notification_id = require('notifier').notify('Installing...', log_levels.INFO, {
--       summary = string.format('[LSP Installer] %s', server.name),
--       timeout = 0,
--     })

--     job_pool:supply(function(callback)
--       server:install_attached({
--         requested_server_version = nil,
--         stdio_sink = {
--           stdout = function(_) end,
--           stderr = function(_) end,
--         }
--       }, function(success)
--         local log_level = success and log_levels.INFO or log_levels.ERROR
--         local message = success and 'Installed' or 'An error occurred'

--         require('notifier').notify(message, log_level, {
--           -- icon = '', -- Not yet part of notifier options
--           replaces_id = notification_id,
--           timeout = 2000,
--         })

--         callback()
--       end)
--     end)
--   end
-- end

-- Setup the default client capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Configure the buffer when attaching to them
local on_attach = function(client, bufnr)
  local function bmap(...) require('cdejoye.utils').bmap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  bmap('<C-]>', [[<cmd>lua require('cdejoye.lsp').buf.definition()<CR>]])
  bmap('<C-w><C-]>', [[<cmd>lua require('cdejoye.lsp').buf.definition('vsplit')<CR>]])
  bmap('<C-A-]>', [[<cmd>lua require('cdejoye.lsp').buf.type_definition()<CR>]])
  bmap('<C-w><C-A-]>', [[<cmd>lua require('cdejoye.lsp').buf.type_definition('vsplit')<CR>]])
  bmap('gD', [[<cmd>lua require('cdejoye.lsp').buf.declaration()<CR>]])
  bmap('gdd', [[<cmd> lua require('cdejoye.lsp').buf.definition()<CR>]])
  bmap('<C-w>gdd', [[<cmd>lua require('cdejoye.lsp').buf.definition('vsplit')<CR>]])
  bmap('gdi', [[<cmd> lua require('cdejoye.lsp').buf.implementation()<CR>]])
  bmap('<C-w>gdi', [[<cmd>lua require('cdejoye.lsp').buf.implementation('vsplit')<CR>]])
  bmap('gdt', [[<cmd> lua require('cdejoye.lsp').buf.type_definition()<CR>]])
  bmap('<C-w>gdt', [[<cmd>lua require('cdejoye.lsp').buf.type_definition('vsplit')<CR>]])
  bmap('gdr', [[<cmd> lua require('cdejoye.lsp').buf.references()<CR>]])
  bmap('<C-w>gdr', [[<cmd>lua require('cdejoye.lsp').buf.references('vsplit')<CR>]])

  bmap('gh', [[<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>]])
  -- bmap('<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  -- bmap('<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  -- bmap('<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
  bmap('<leader>rn', [[<cmd>lua vim.lsp.buf.rename()<CR>]])
  bmap('<leader>ca', [[<cmd>lua vim.lsp.buf.code_action()<CR>]])
  bmap('<leader>ca', [[<cmd>lua vim.lsp.buf.range_code_action()<CR>]], 'v')

  -- vim.cmd([[ autocmd! CursorHold  <buffer> lua vim.lsp.buf.document_highlight() ]])
  -- vim.cmd([[ autocmd! CursorHoldI <buffer> lua vim.lsp.buf.document_highlight() ]])
  -- vim.cmd([[ autocmd! CursorMoved <buffer> lua vim.lsp.buf.clear_references() ]])

  bmap('[d', [[<cmd>lua require('lspsaga.diagnostic').navigate('prev')()<CR>]])
  bmap(']d', [[<cmd>lua require('lspsaga.diagnostic').navigate('next')()<CR>]])
  bmap('<leader>od', [[<cmd>lua require('trouble').open('lsp_document_diagnostics')<CR>]])
  bmap('<leader>ld', [[<cmd>lua require('telescope.builtin').diagnostics()<CR>]])

  bmap('<leader>ls', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])

  bmap('<Leader>ff', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>')

  bmap('vv', [[<cmd>lua require('lsp-selection-range').trigger()<CR>]], 'n')
  bmap('vv', [[<cmd>lua require('lsp-selection-range').expand()<CR>]], 'v')

  lsp_signature.on_attach({
    hi_parameter = 'Visual',
    -- padding = ' ', -- Generate an error when using the toggle key to show the signature
    floating_window_above_cur_line = true,
    handler_opts = {
      border = 'single', -- double, rounded, single, shadow, none
    },
    hint_enable = false, -- Disable virtual text
    toggle_key = '<C-s>',
  }, bufnr)
end

-- nvim-cmp supports additional completion capabilities
if pcall(require, 'cmp_nvim_lsp') then
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
end

capabilities = lsp_selection_range.update_capabilities(capabilities)

if use_phpactor then
  servers_options.intelephense = nil
  require('lspconfig').phpactor.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = { ['language_server_completion.trim_leading_dollar'] = true },
  })
end

-- Setup the installed servers
lsp_installer.on_server_ready(function(server)
  local options = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  if servers_options[server.name] then
    local server_options = servers_options[server.name]

    if 'function' == type(server_options) then
      options = server_options(options)
    elseif 'table' == type(server_options) then
      options = vim.tbl_extend('force', options, server_options)
    end

    server:setup(options)
  end
end)

-- Setup null-ls
require('cdejoye.config.null-ls').setup(on_attach, capabilities)
