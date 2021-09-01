require('packer').use'RRethy/nvim-base16'

-- local o = vim.o
local g = vim.g
-- local has = function (value)
--   return 1 == vim.fn.has(value)
-- end

-- require('packer').use('chriskempson/base16-vim')

-- o.background = 'dark'

-- if false == has(gui_running) and false == o.termguicolors then
--   g.base16colorspace = 256
-- end

local colorschemeFile = g.my_vim_dir .. '/colorscheme.vim'
if vim.fn.filereadable(colorschemeFile) then
  vim.cmd('source '.. colorschemeFile)
else
  vim.cmd('colorscheme base16-tomorrow-night')
end

-- vim.fn.Base16hi('Comment', '', '', '', '', 'italic')

-- vim: ts=2 sw=2 et fdm=marker
