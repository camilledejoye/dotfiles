--- @module lazy
--- @type LazySpec
return {
  'phpactor/phpactor',
  build = 'composer install -o',
  dependencies = {
    {
      'camilledejoye/phpactor-mappings',
      init = function()
        -- Enable while experimental
        vim.g.phpactorInputListStrategy = 'phpactor#input#list#fzf'
        vim.g.phpactorQuickfixStrategy = 'phpactor#quickfix#fzf'

        -- phpactor-mapping
        vim.g.phpactorActivateOverlapingMappings = true
      end,
    },
    'junegunn/fzf.vim',
    { 'junegunn/fzf', build = ':call fzf#install()' },
  },
  ft = 'php',
  keys = {
    {
      '<Leader>pp',
      '<Plug>phpactorContextMenu',
      desc = '[Phpactor] Open context menu',
    },
    {
      '<Leader>pt',
      '<Plug>phpactorTransform',
      desc = '[Phpactor] Open transformation menu',
    },
    {
      '<Leader>pe',
      '<Plug>phpactorClassExpand',
      desc = '[Phpactor] Expand the class name, under the curor, as a FQCN',
    },
  },
}
