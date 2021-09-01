local g = vim.g

require('packer').use('powerman/vim-plugin-viewdoc')

vim.opt.keywordprg = [[:ViewDoc <cword>]]

g.no_viewdoc_abbrev = 1 -- Disable abbreviations
g.no_viewdoc_maps = 1 -- Disable mappings
g.viewdoc_open = 'botright vnew' --How to open the help window
g.viewdoc_openempty = 0 -- Do not open window when doc is not found

-- vim:ts=2:sw=2:et:fdm=marker
