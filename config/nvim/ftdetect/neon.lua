vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = {
    '*.neon',
    '*.neon.dist',
  },
  callback = function()
    vim.bo.filetype = 'yaml'
  end,
})
