local g = vim.g

require('packer').use('alvan/vim-closetag')

g.closetag_filetypes = 'html,xhtml,jsx,twig,riot,html.twig'
g.closetag_xhtml_filetypes = 'html,xhtml,jsx,twig,riot,html.twig'

-- vim: ts=2 sw=2 et fdm=marker
