local lint = require('lint')

lint.linters_by_ft = {
  php = {
    'phpstan',
    'php_cs_fixer',
  },
  lua = { 'luacheck' },
  sh = { 'shellcheck' },
}

vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'BufWritePost' }, {
  callback = function()
    lint.try_lint()
  end,
})

lint.linters.phpstan = require('cdejoye.config.nvim-lint.phpstan')
lint.linters.php_cs_fixer = require('cdejoye.config.nvim-lint.php-cs-fixer')
