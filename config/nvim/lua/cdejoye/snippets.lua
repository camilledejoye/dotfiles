local g = vim.g

require('packer').use {
  'SirVer/ultisnips',
  'honza/vim-snippets',
}

g.UltiSnipsExpandTrigger		= "<Tab>"
g.UltiSnipsJumpForwardTrigger	= "<c-j>"
g.UltiSnipsJumpBackwardTrigger	= "<c-k>"
g.UltiSnipsRemoveSelectModeMappings = 0

-- vim: ts=2 sw=2 et fdm=marker
