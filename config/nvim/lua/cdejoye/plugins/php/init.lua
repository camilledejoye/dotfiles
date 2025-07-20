return {
  require('cdejoye.plugins.php.phpactor'),

  {
    'camilledejoye/vim-php-refactoring-toolbox',
    branch = 'improvements',
    init = function()
      vim.g.vim_php_refactoring_use_default_mapping = 0
    end,
    ft = 'php',
    keys = {
      { '<Leader>pi', [[<cmd>call PhpInline()<CR>]] },
    },
  },
}
