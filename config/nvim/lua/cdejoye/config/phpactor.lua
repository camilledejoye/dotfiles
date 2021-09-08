local g = vim.g

-- Enable while experimental
g.phpactorInputListStrategy = 'phpactor#input#list#fzf'
g.phpactorQuickfixStrategy = 'phpactor#quickfix#fzf'

-- phpactor-mapping
g.phpactorActivateOverlapingMappings = true
g.phpactorCustomMappings = {
  { '<Leader>pp', '<Plug>phpactorContextMenu', 'n' },
  { '<Leader>pn', '<Plug>phpactorNavigate', 'n' },
  { '<Leader>pt', '<Plug>phpactorTransform', 'n' },
  { '<Leader>pe', '<Plug>phpactorClassExpand', 'n' },
  { '<Leader>pE', '<Plug>phpactorClassExpand <BAR> :normal! Bi\\<CR>', 'n' },
}