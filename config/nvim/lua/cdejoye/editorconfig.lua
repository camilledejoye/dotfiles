local g = vim.g

require('packer').use('editorconfig/editorconfig-vim')

g.EditorConfig_exclude_patterns = {'fugitive://.\\*'}
g.EditorConfig_disable_rules = {'trim_trailing_whitespace'}

-- vim: et ts=2 sw=2 fdm=marker
