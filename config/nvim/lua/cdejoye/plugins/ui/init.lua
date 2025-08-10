--- @module lazy
--- @type table<string|LazySpec>
return {
  require('cdejoye.plugins.ui.tree-sitter'),
  require('cdejoye.plugins.ui.lualine'),
  require('cdejoye.plugins.ui.noice'),
  require('cdejoye.plugins.ui.scrollbar'),
  require('cdejoye.plugins.ui.notifications'),
  require('cdejoye.plugins.ui.indent'),
  'camilledejoye/vim-cleanfold',
}
