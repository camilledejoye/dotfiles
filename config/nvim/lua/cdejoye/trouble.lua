-- https://github.com/folke/trouble.nvim
local map = require('cdejoye/utils').map

require('packer').use {
  "folke/trouble.nvim",
  requires = "kyazdani42/nvim-web-devicons",
  config = function()
    require("trouble").setup {
      mode = "quickfix", -- "lsp_workspace_diagnostics", "lsp_document_diagnostics", "quickfix", "lsp_references", "loclist"
    }
  end
}

map('<Leader>xx', '<cmd>TroubleToggle<CR>')
map('<Leader>xw', '<cmd>TroubleToggle lsp_workspace_diagnostics<CR>')
map('<Leader>xd', '<cmd>TroubleToggle lsp_document_diagnostics<CR>')
map('<Leader>xq', '<cmd>TroubleToggle quickfix<CR>')
map('<Leader>xr', '<cmd>TroubleToggle lsp_references<CR>')
map('<Leader>xl', '<cmd>TroubleToggle loclist<CR>')

-- telescope integration
if pcall(require, 'telescope') then
  local trouble = require('trouble')

  require('telescope').setup {
    defaults = {
      mappings = {
        n = { ['<C-t>'] = trouble.open_with_trouble },
        i = { ['<C-t>'] = trouble.open_with_trouble },
      }
    }
  }
end
