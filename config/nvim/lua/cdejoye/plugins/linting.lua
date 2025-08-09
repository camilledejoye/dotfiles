--- @module lazy
--- @type LazySpec
return {
  {
    'mfussenegger/nvim-lint',
    event = 'VeryLazy',
    config = function()
      local lint = require('lint')

      vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'BufWritePost' }, {
        callback = function()
          -- Passing `ignore_errors = true` will prevent seing annoying errors when the linters are not available in
          -- a project
          -- It also means I don't see an error for legitimate cases... Will do for now
          lint.try_lint(nil, { ignore_errors = true })
        end,
      })

      vim.env.ESLINT_D_PPID = vim.fn.getpid()
      lint.linters_by_ft = {
        php = {
          'phpstan',
          'php_cs_fixer',
        },
        lua = { 'luacheck' },
        sh = { 'shellcheck' },
        typescript = { 'eslint_d' },
      }

      lint.linters.phpstan = require('cdejoye.config.nvim-lint.phpstan')
      lint.linters.php_cs_fixer = require('cdejoye.config.nvim-lint.php-cs-fixer')
      lint.linters.eslint_d = require('cdejoye.config.nvim-lint.eslint_d')
    end,
  },
  {
    'rshkarin/mason-nvim-lint',
    event = 'VeryLazy',
    opts = {
      -- Usually installed per project to have specific versions
      ignore_install = { 'phpstan', 'php_cs_fixer', 'phpcs' },
    },
  },
}
