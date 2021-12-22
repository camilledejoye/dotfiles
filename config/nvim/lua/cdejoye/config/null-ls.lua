local builtins = require('null-ls').builtins
local helpers = require('null-ls.helpers')

local M = {}

local phpcsfixer = helpers.make_builtin {
  name = 'php-cs',
  method = require('null-ls.methods').internal.DIAGNOSTICS,
  filetypes = { 'php' },
  generator_opts = {
    command = 'php-cs-fixer',
    -- command = './vendor/bin/php-cs-fixer',
    args = { 'fix', '--dry-run', '--using-cache=no', '--format=gitlab', '--show-progress=none', '--no-interaction', '-' },
    format = 'json_raw',
    to_stdin = true,
    from_stderr = false,
    check_exit_code = function(code)
      return code <= 1
    end,
    on_output = function(params)
      local diagnostics = {}

      for _, json_diagnostic in ipairs(params.output or {}) do
        local diagnostic = {
          row = 0, -- php-cs-fixer is not a real linter ant can't provide more information
          message = json_diagnostic.description,
          source = 'php-cs', -- shown as #{s} when formatting the diagnostic
        }

        table.insert(diagnostics, diagnostic)
      end

      return diagnostics
    end,
  },
  factory = helpers.generator_factory,
}

function M.setup (on_attach, _)
  require('null-ls').setup {
    diagnostics_format = '#{m} [#{s}]',
    sources = {
      -- builtins.code_actions.gitsigns,
      builtins.diagnostics.shellcheck,
      builtins.diagnostics.phpstan.with {
        -- alternatives to define manually but make sure the cwd is correct !
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#local-executables
        only_local = 'vendor/bin',
        -- command = './vendor/bin/phpstan',
        -- condition = function(_)
        --   return vim.fn.executable('./vendor/bin/phpstan')
        -- end,
      },
      -- builtins.formatting.phpcbf,
      -- builtins.diagnostics.phpcs.with {
      --   only_local = 'vendor/bin',
      -- },
      builtins.formatting.phpcsfixer.with {
        only_local = 'vendor/bin',
      },
      phpcsfixer.with {
        only_local = 'vendor/bin',
      },
    },
    on_attach = on_attach,
  }
end

return M
