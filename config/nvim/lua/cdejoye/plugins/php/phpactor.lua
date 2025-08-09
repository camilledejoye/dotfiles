--- @module lazy
--- @type LazySpec
return {
  'phpactor/phpactor',
  build = 'composer install -o',
  init = function()
    vim.g.phpactorInputListStrategy = 'phpactor#input#list#fzf'
    vim.g.phpactorQuickfixStrategy = 'phpactor#quickfix#fzf'
  end,
  dependencies = {
    'junegunn/fzf.vim',
    { 'junegunn/fzf', build = ':call fzf#install()' },
  },
  keys = {
    {
      '<Leader>pp',
      '<cmd>call phpactor#ContextMenu()<CR>',
      desc = '[phpactor] Open context menu',
      ft = 'php',
    },
    {
      '<Leader>pt',
      '<cmd>:call phpactor#Transform()<CR>',
      desc = '[phpactor] Open transformation menu',
      ft = 'php',
    },
    {
      '<Leader>pe',
      '<cmd>call phpactor#ClassExpand()<CR>',
      desc = '[phpactor] Expand the class name, under the curor, as a FQCN',
      ft = { 'php', 'yaml' },
    },
    {
      'cv',
      '<cmd>set opfunc=phpactor#ExtractExpression<CR>g@',
      desc = '[phpactor] Extract into variable',
      ft = 'php',
    },
    {
      'cv',
      ':<C-U>call phpactor#ExtractExpression(visualmode())<CR>',
      desc = '[phpactor] Extract into variable',
      mode = 'x',
      ft = 'php',
    },
    {
      'cvv',
      '<cmd>set opfunc=phpactor#ExtractExpression<CR>^g@$',
      desc = '[phpactor] Extract into variable',
      ft = 'php',
    },
    {
      'cm',
      '<cmd>set opfunc=phpactor#ExtractMethod<CR>g@',
      desc = '[phpactor] Extract into method',
      ft = 'php',
    },
    {
      'cm',
      ':<C-U>call phpactor#ExtractMethod(visualmode())<CR>',
      desc = '[phpactor] Extract into method',
      mode = 'x',
      ft = 'php',
    },
    {
      'cmm',
      '<cmd>set opfunc=phpactor#ExtractMethod<CR>^g@$',
      desc = '[phpactor] Extract into method',
      ft = 'php',
    },
    {
      'cc',
      '<cmd>call phpactor#ExtractConstant()<CR>',
      desc = '[phpactor] Extract into constant',
      ft = 'php',
    },
    {
      'yu',
      '<cmd>call phpactor#UseAdd()<CR>',
      desc = '[phpactor] Add import statement for the class name under the cursor',
      ft = 'php',
    },
  },
}
