-- vim: ts=2 sw=2 et

local g = vim.g

require('packer').use('w0rp/ale')

g['airline#extensions#ale#enabled'] = 1
g.ale_yaml_yamllint_options = '-d relaxed'
g.ale_fixers = { php = {
  'php_cs_fixer',
  'remove_trailing_lines',
  'trim_whitespace',
}}
g.ale_php_cs_fixer_options = '--using-cache=no --quiet --no-interaction'
g.ale_php_phpstan_level = 1

vim.api.nvim_set_keymap('n', '<Leader>fs', '<Plug>(ale_fix)<CR>', { silent = true })
