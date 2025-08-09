vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = {
    'Caddyfile',
    '*.caddy',
  },
  callback = function()
    vim.bo.filetype = 'caddy'
  end,
})
