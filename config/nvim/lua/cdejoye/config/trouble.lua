-- https://github.com/folke/trouble.nvim
local map = require('cdejoye.utils').map

local trouble = require('trouble')

trouble.setup {
  mode = 'quickfix', -- 'lsp_workspace_diagnostics', 'lsp_document_diagnostics', 'quickfix', 'lsp_references', 'loclist'
}

-- Telescope integration
if pcall(require, 'telescope') then
  require('telescope').setup {
    defaults = {
      mappings = {
        n = { ['<C-l>'] = trouble.open_with_trouble },
        i = { ['<C-l>'] = trouble.open_with_trouble },
      }
    }
  }
end

-- r for Review because I already have mappings on <Leader>t for tests
map('<Leader>rr', '<cmd>TroubleToggle<CR>')
map('<Leader>rwd', '<cmd>TroubleToggle lsp_workspace_diagnostics<CR>')
map('<Leader>rdd', '<cmd>TroubleToggle lsp_document_diagnostics<CR>')
map('<Leader>rqf', '<cmd>TroubleToggle quickfix<CR>')
map('<Leader>rrf', '<cmd>TroubleToggle lsp_references<CR>')
map('<Leader>rll', '<cmd>TroubleToggle loclist<CR>')

vim.cmd([[
augroup cdejoye_trouble_buffer_mappings
  autocmd!
  autocmd FileType Trouble nnoremap <buffer><silent> zk <cmd>lua require('cdejoye.trouble').previous_fold()<CR>
  autocmd FileType Trouble nnoremap <buffer><silent> zj <cmd>lua require('cdejoye.trouble').next_fold()<CR>
augroup END
]])
