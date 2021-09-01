require('packer').use({
  'norcalli/nvim-colorizer.lua',
  opt = true,
})

vim.api.nvim_set_keymap('n', 'yoC', ':packadd nvim-colorizer.lua <BAR> :ColorizerToggle<CR>', { noremap = true, silent = true })

-- vim: ts=2 sw=2 et fdm=marker
