local g = vim.g

require('packer').use {
  'StanAngeloff/php.vim',
  'camilledejoye/php-foldexpr',
  'lumiliet/vim-twig',

  'sniphpets/sniphpets-common',
  'sniphpets/sniphpets-symfony',
  'sniphpets/sniphpets-phpunit',
  'sniphpets/sniphpets-doctrine',
  'sniphpets/sniphpets-postfix-codes',
  'sniphpets/sniphpets',
}

-- php.vim configurations {{{

g.php_html_in_strings = 1
g.sql_type_default    = 'sqloracle' -- SQL syntax colorscheme
g.PHP_noArrowMatching = 1 -- Properly aligns "->" on multiple lines

vim.cmd([[
augroup MyPhpConfiguration
  autocmd!
  autocmd FileType php hi! def link phpDocTags       phpConstants
  autocmd FileType php hi! def link phpDocParam      phpType
  autocmd FileType php hi! def link phpDocIdentifier phpIdentifier
augroup END
]])

-- }}}

-- vim: et ts=2 sw=2 fdm=marker
