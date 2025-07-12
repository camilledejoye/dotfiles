vim.lsp.set_log_level('debug')

-- vim.lsp.start({
--   name = 'lemminx',
--   cmd = { 'lemminx' },
--   filetypes = { 'xml', 'xsd', 'xsl', 'xslt', 'svg' },
--   -- root_dir = require('lspconfig.util').find_git_ancestor,
--   root_dir = vim.fs.dirname(vim.fs.find({'composer.json'}, { upward = true })[1]),
--   single_file_support = true,
-- })

vim.lsp.start({
  name = 'intelephense',
  cmd = { 'intelephense', '--stdio' },
  filetypes = { 'php' },
  root_dir = vim.fs.dirname(vim.fs.find({'composer.json'}, { upward = true })[1]),
})

-- vim.api.nvim_create_autocmd({'BufEnter'}, {
--   callback = function(info)
--     print(info.buf)
--     vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', {
--       buf = buf,
--     })
--   end,
-- })
