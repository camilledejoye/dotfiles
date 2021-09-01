local use = require('packer').use
local g = vim.g

use { 'phpactor/phpactor', run = 'composer install -o' }
use('camilledejoye/phpactor-mappings')

-- phpactor {{{

-- Use Phpactor for omni-completion
vim.cmd([[
augroup elyphpactor
  autocmd!
  autocmd FileType php setlocal omnifunc=phpactor#Complete
augroup END
]])

g.phpactorOmniError = true -- Enable useful error messages when completion is invoked

-- Enable while Experimental
g.phpactorInputListStrategy = 'phpactor#input#list#fzf'
g.phpactorQuickfixStrategy = 'phpactor#quickfix#fzf'

-- }}}

-- phpactor-mapping {{{

g.phpactorActivateOverlapingMappings = true

-- Should be `pm` to be logic but `pp` is easiest and faster since I use it a lot
g.phpactorCustomMappings = {
  { '<Leader>pp', '<Plug>phpactorContextMenu', 'n' },
  { '<Leader>pn', '<Plug>phpactorNavigate', 'n' },
  { '<Leader>pt', '<Plug>phpactorTransform', 'n' },
  { '<Leader>pe', '<Plug>phpactorClassExpand', 'n' },
  { '<Leader>pE', '<Plug>phpactorClassExpand <BAR> :normal! Bi\\<CR>', 'n' },
}

-- }}}

-- vim: et ts=2 sw=2 fdm=marker
