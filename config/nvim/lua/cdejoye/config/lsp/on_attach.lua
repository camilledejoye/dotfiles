local M = {}

-- Configure the buffer when attaching to them
function M.on_attach(client, bufnr)
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

  bmap('gh', [[<cmd>Lspsaga hover_doc<CR>]])
  -- bmap('<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  -- bmap('<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  -- bmap('<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
  bmap('<leader>rn', [[<cmd>lua vim.lsp.buf.rename()<CR>]])
  bmap('<leader>ca', [[<cmd>lua vim.lsp.buf.code_action()<CR>]])
  bmap('<leader>ca', [[<cmd>lua vim.lsp.buf.code_action()<CR>]], 'v')

  -- vim.cmd([[ autocmd! CursorHold  <buffer> lua vim.lsp.buf.document_highlight() ]])
  -- vim.cmd([[ autocmd! CursorHoldI <buffer> lua vim.lsp.buf.document_highlight() ]])
  -- vim.cmd([[ autocmd! CursorMoved <buffer> lua vim.lsp.buf.clear_references() ]])

  bmap('[d', [[<cmd>Lspsaga diagnostic_jump_prev<CR>]])
  bmap(']d', [[<cmd>Lspsaga diagnostic_jump_next<CR>]])
  bmap('<leader>ld', [[<cmd>lua require('telescope.builtin').diagnostics()<CR>]])

  bmap('<leader>ls', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])

  bmap('vv', [[<cmd>lua require('lsp-selection-range').trigger()<CR>]], 'n')
  bmap('vv', [[<cmd>lua require('lsp-selection-range').expand()<CR>]], 'v')

  if 8 <= vim.version().minor then
    bmap('<Leader>ff', function ()
      vim.lsp.buf.format({
        async = true,
        filter = function (formatting_client)
          -- Only allowed specific servers to format
          return 'null-ls' == formatting_client.name
          or 'jsonls' == formatting_client.name
        end,
      })
    end)
  else
    bmap('<Leader>ff', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>')
    if not ('null-ls' == client.name or 'jsonls' == client.name) then
      client.server_capabilities.document_formatting = false
    end
  end

  require('cdejoye.config.lsp.signature').on_attach(client, bufnr)
end

return M
