-- LSP settings
local nvim_lsp = require('lspconfig')
local lsp_status = require('lsp-status')
local is_lsp_signature_loaded, lsp_signature = pcall(require, 'lsp_signature')
local servers = { phpactor = { -- Servers to enable with their specific configuration
  init_options = {
    ['language_server_completion.trim_leading_dollar'] = true,
  }
}}
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<C-w><C-]>', [[<cmd>lua require('cdejoye.lsp').buf.definition('vsplit')<CR>]], opts)
  buf_set_keymap('n', '<C-A-]>', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<C-w><C-A-]>', [[<cmd>lua require('cdejoye.lsp').buf.type_definition('vsplit')<CR>]], opts)
  buf_set_keymap('n', 'gdd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gdD', [[<cmd>lua require('cdejoye.lsp').buf.definition('vsplit')<CR>]], opts)
  buf_set_keymap('n', 'gdi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gdI', [[<cmd>lua require('cdejoye.lsp').buf.implementation('vsplit')<CR>]], opts)
  buf_set_keymap('n', 'gdt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gdT', [[<cmd>lua require('cdejoye.lsp').buf.type_definition('vsplit')<CR>]], opts)
  buf_set_keymap('n', 'gdr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gdR', [[<cmd>lua require('cdejoye.lsp').buf.references('vsplit')<CR>]], opts)

  buf_set_keymap('n', 'gh', [[<cmd>lua require('lspsaga.hover').render_hover_doc()()<CR>]], opts)
  buf_set_keymap('n', '<C-s>', [[<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>]], opts)
  buf_set_keymap('i', '<C-s>', [[<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>]], opts)
  -- buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>rn', [[<cmd>lua require('lspsaga.rename').rename()<CR>]], opts)
  buf_set_keymap('n', '<leader>ca', [[<cmd>lua require('lspsaga.codeaction').code_action()<CR>]], opts)
  buf_set_keymap('v', '<leader>ca', [[<cmd>lua require('lspsaga.codeaction').range_code_action()<CR>]], opts)
  buf_set_keymap('n', '<leader>sd', [[<cmd>lua require('lspsaga.diagnostic').show_line_diagnostics()<CR>]], opts)

  buf_set_keymap('n', '[d', [[<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_prev()<CR>]], opts)
  buf_set_keymap('n', ']d', [[<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<CR>]], opts)
  buf_set_keymap('n', '<leader>od', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- buf_set_keymap('n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
  buf_set_keymap('n', '<Leader>ff', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]

  lsp_signature.on_attach({
    -- To work with lspsaga
    bind = false,
    use_lspsaga = true,

    -- Not relevant anymore because it's the popup from lspsaga which is show
    -- hi_parameter = 'Visual',
    -- trigger_on_newline = true,
    -- padding = ' ', -- Disable because it causes a bug when toggling the signature helper
    -- floating_window_above_cur_line = true,
  }, bufnr)
  lsp_status.on_attach(client)
end

-- nvim-cmp supports additional completion capabilities
if pcall(require, 'cmp_nvim_lsp') then
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
end

for server, config in pairs(servers) do
  nvim_lsp[server].setup(vim.tbl_deep_extend('force', {
    on_attach = on_attach,
    capabilities = capabilities,
  }, config))
end

require('cdejoye.config.lua-language-server').setup(on_attach, capabilities)
