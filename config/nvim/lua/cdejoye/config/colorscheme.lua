local vim_dir = vim.fn.fnamemodify(vim.env.MYVIMRC, ':h')
local colorschemeFile = vim_dir .. '/colorscheme.vim'

if vim.fn.filereadable(colorschemeFile) then
  vim.cmd('source '.. colorschemeFile)
else
  vim.cmd('colorscheme base16-tomorrow-night')
end
