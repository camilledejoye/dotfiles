local builtins = require('null-ls').builtins
local helpers = require('null-ls.helpers')

local M = {}

function M.setup(on_attach, _)
  require('null-ls').config {
    diagnostics_format = '#{m} [#{s}]',
    sources = {
      -- builtins.code_actions.gitsigns,
      builtins.diagnostics.shellcheck,
      builtins.diagnostics.phpstan.with {
        command = './vendor/bin/phpstan',
        condition = function(_)
          return vim.fn.executable('./vendor/bin/phpstan')
        end,
      },
      -- builtins.formatting.phpcbf,
      -- builtins.diagnostics.phpcs,
      builtins.formatting.phpcsfixer.with {
        command = './vendor/bin/php-cs-fixer',
        condition = function(_)
          return vim.fn.executable('./vendor/bin/php-cs-fixer')
        end,
      },
      helpers.make_builtin {
        name = 'php-cs',
        method = require('null-ls.methods').internal.DIAGNOSTICS,
        filetypes = { 'php' },
        generator_opts = {
          command = './vendor/bin/php-cs-fixer',
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
      },
    }
  }

  require('lspconfig')['null-ls'].setup {
    on_attach = on_attach,
  }
end

return M
