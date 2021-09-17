-- LSP settings
local nvim_lsp = require('lspconfig')
local lsp_status = require('lsp-status')
local lsp_signature = require('lsp_signature')
local hi = require('cdejoye.utils').hi

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
require('vim.lsp.handlers')['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
  config = vim.tbl_extend('force', config or {}, { virtual_text = false })

  return require('vim.lsp.diagnostic').on_publish_diagnostics(err, result, ctx, config)
end

-- Servers to enable with their specific configuration
local servers = { phpactor = {
  init_options = {
    ['language_server_completion.trim_leading_dollar'] = true,
  }
}}

-- Setup the default client capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)

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
  bmap('gdD', [[<cmd>lua require('cdejoye.lsp').buf.definition('vsplit')<CR>]])
  bmap('gdi', [[<cmd> lua require('cdejoye.lsp').buf.implementation()<CR>]])
  bmap('gdI', [[<cmd>lua require('cdejoye.lsp').buf.implementation('vsplit')<CR>]])
  bmap('gdt', [[<cmd> lua require('cdejoye.lsp').buf.type_definition()<CR>]])
  bmap('gdT', [[<cmd>lua require('cdejoye.lsp').buf.type_definition('vsplit')<CR>]])
  bmap('gdr', [[<cmd> lua require('cdejoye.lsp').buf.references()<CR>]])
  bmap('gdR', [[<cmd>lua require('cdejoye.lsp').buf.references('vsplit')<CR>]])

  bmap('gh', [[<cmd>lua require('lspsaga.hover').render_hover_doc()()<CR>]])
  -- bmap('<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  -- bmap('<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  -- bmap('<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
  bmap('<leader>rn', [[<cmd>lua require('lspsaga.rename').rename()<CR>]])
  bmap('<leader>ca', [[<cmd>lua require('telescope.builtin').lsp_code_actions()<CR>]])
  bmap('<leader>ca', [[<cmd>lua require('telescope.builtin').lsp_range_code_actions()<CR>]], 'v')

  bmap('[d', [[<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_prev()<CR>]])
  bmap(']d', [[<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<CR>]])
  bmap('<leader>od', [[<cmd>lua require('trouble').open('lsp_document_diagnostics')<CR>]])
  bmap('<leader>ld', [[<cmd>lua require('telescope.builtin').lsp_document_diagnostics()<CR>]])

  bmap('<leader>ls', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])

  bmap('<Leader>ff', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  vim.cmd [[ command! -buffer Format execute 'lua vim.lsp.buf.formatting()' ]]

  lsp_signature.on_attach({
    hi_parameter = 'Visual',
    trigger_on_newline = true,
    -- padding = ' ', -- Generate an error when using the toggle key to show the signature
    floating_window_above_cur_line = true,
    hint_enable = false, -- Disable virtual text
    -- fix_pos = true,
    toggle_key = '<C-s>',
  }, bufnr)

  lsp_status.on_attach(client)
end

-- nvim-cmp supports additional completion capabilities
if pcall(require, 'cmp_nvim_lsp') then
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
end

-- Setup the configured servers
for server, config in pairs(servers) do
  nvim_lsp[server].setup(vim.tbl_deep_extend('force', {
    on_attach = on_attach,
    capabilities = capabilities,
  }, config))
end

-- Setup Lua LSP server
require('cdejoye.config.lua-language-server').setup(on_attach, capabilities)
require('cdejoye.config.null-ls').setup(on_attach, capabilities)