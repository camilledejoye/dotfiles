--- @module lazy
--- @type LazySpec[]
return {
  require('cdejoye.plugins.tests.coverage'),
  require('cdejoye.plugins.tests.vim-test'),
  -- Neotest is a nice idea but would require work to be able to operate properly and seamlessly
  -- with containers
  -- require('cdejoye.plugins.tests.neotest'),
}
