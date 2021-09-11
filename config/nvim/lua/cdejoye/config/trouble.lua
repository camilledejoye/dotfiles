-- https://github.com/folke/trouble.nvim
local bmap = require('cdejoye.utils').bmap

local trouble = require('trouble')

trouble.setup {
  mode = 'quickfix', -- 'lsp_workspace_diagnostics', 'lsp_document_diagnostics', 'quickfix', 'lsp_references', 'loclist'
}

vim.cmd([[
augroup cdejoye_trouble
  autocmd!
  autocmd FileType Trouble lua require('cdejoye.config.trouble').on_attach(vim.api.nvim_get_current_buf())
augroup END
]])

return {
  on_attach = function (bufnr)
    bmap(bufnr, 'zk', [[<cmd>lua require('cdejoye.trouble').previous_fold()<CR>]])
    bmap(bufnr, 'zj', [[<cmd>lua require('cdejoye.trouble').next_fold()<CR>]])
  end
}
