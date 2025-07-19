local M = {}
local methods = vim.lsp.protocol.Methods

-- Configure the buffer when attaching to them
function M.on_attach(client, bufnr)
  local function bmap(...)
    require('cdejoye.utils').bmap(bufnr, ...)
  end
  vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })

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
  bmap('<leader>rn', [[<cmd>lua vim.lsp.buf.rename()<CR>]])

  -- Neovim native
  -- bmap('<leader>ca', [[<cmd>lua vim.lsp.buf.code_action()<CR>]])
  -- bmap('<leader>ca', [[<cmd>lua vim.lsp.buf.code_action()<CR>]], 'v')
  -- Lspsaga
  bmap('<leader>ca', [[<cmd>Lspsaga code_action<CR>]])
  bmap('<leader>ca', [[<cmd>Lspsaga code_action<CR>]], 'v')

  if client:supports_method(methods.textDocument_documentHighlight) then
    vim.cmd([[ autocmd! CursorHold  <buffer> lua vim.lsp.buf.document_highlight() ]])
    vim.cmd([[ autocmd! CursorHoldI <buffer> lua vim.lsp.buf.document_highlight() ]])
    vim.cmd([[ autocmd! CursorMoved <buffer> lua vim.lsp.buf.clear_references() ]])
  end

  bmap('[d', [[<cmd>Lspsaga diagnostic_jump_prev<CR>]])
  bmap(']d', [[<cmd>Lspsaga diagnostic_jump_next<CR>]])

  bmap('<leader>ls', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]])

  bmap('vv', [[<cmd>lua require('lsp-selection-range').trigger()<CR>]], 'n')
  bmap('vv', [[<cmd>lua require('lsp-selection-range').expand()<CR>]], 'v')

  bmap('gqq', function()
    vim.lsp.buf.format({ async = true })
  end, 'nv')
  bmap('gq', function()
    vim.lsp.buf.format({ async = true })
  end, 'o')

  bmap('K', function()
    vim.lsp.buf.hover({ border = 'single' })
  end)

  if client:supports_method(methods.textDocument_foldingRange) then
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_set_option_value('foldmethod', 'expr', { win = win })
    vim.api.nvim_set_option_value('foldexpr', 'v:lua.vim.lsp.foldexpr()', { win = win })
  end
end

return M
