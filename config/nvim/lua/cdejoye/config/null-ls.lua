local builtins = require('null-ls').builtins
local helpers = require('null-ls.helpers')
local utils = require('null-ls.utils')
local cache = require('null-ls.helpers.cache')
local command_resolver = require('null-ls.helpers.command_resolver')

--- First try to find the command in the PATH
--- Otherwise look into tools/
--- Finally check in vendor/bin/
---@param command_name string
local function php_command_resolver(command_name)
  ---@param params NullLsParams
  return cache.by_bufnr(function(params)
    params.command = command_name

    if utils.is_executable(params.command) then
      return params.command
    end

    local command = command_resolver.generic('tools')(params)
    if command then
      return command
    end

    return command_resolver.generic(utils.path.join('vendor', 'bin'))(params)
  end)
end

--- Fake a linter for php-cs-fixer
--- All the diagnostics will be shown on the first line because we don't have line information
---
--- TODO It might be possible to try to find out lines with errors by scanning the resulted diff but
--- I don't see how to link the diffs to the correct rule so even with this solution I might need
--- to show all errors on each impacted line ?
local phpcsfixer = helpers.make_builtin {
  name = 'phpcsfixer',
  meta = {
    url = "https://github.com/FriendsOfPhp/PHP-CS-Fixer",
    description = "Formatter for php files.",
  },
  method = require('null-ls.methods').internal.DIAGNOSTICS,
  filetypes = { 'php' },
  generator_opts = {
    command = 'php-cs-fixer',
    args = {
      'fix',
      '--dry-run',
      '--using-cache=no',
      '--format=gitlab',
      '--show-progress=none',
      '--no-interaction',
      '-',
    },
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
          source = 'php-cs-fixer', -- shown as #{s} when formatting the diagnostic
        }

        table.insert(diagnostics, diagnostic)
      end

      return diagnostics
    end,
  },
  factory = helpers.generator_factory,
}

---@class ExtendedNullLsParams @parent NullLsParams
---@field bufname_match fun(glob: string): boolean #Match the bufname against a glob pattern

---@alias ShouldRunCallback fun(params: ExtendedNullLsParams): boolean

--- Decides, at runtime, if a source should be run or not
---
---@param callback ShouldRunCallback #Callback used to determine if the source should be run
---@return fun(params: NullLsParams): boolean #Wrapper around `callback` to provide extended params
local function should_run(callback)
  vim.validate({callback = { callback, 'function' }})

  ---@param params NullLsParams
  return function(params)
    local client = vim.lsp.get_client_by_id(params.client_id)
    local root_dir = client.config.root_dir
    params.bufname_match = function(glob)
      glob = root_dir..'/'..glob

      return vim.regex(vim.fn.glob2regpat(glob)):match_str(params.bufname)
    end

    return callback(params)
  end
end

---@params params ExtendedNullLsParams
local should_run_phpcsfixer = should_run(function(params)
  return nil ~= php_command_resolver('php-cs-fixer')(params) and not(
    params.bufname_match('tests/')
    or params.bufname_match('vendor/*')
    or params.bufname_match('var/*')
  )
end)

---@params params ExtendedNullLsParams
local should_run_phpcs = should_run(function(params)
  return not(
    params.bufname_match('src/**/spec/*')
    or params.bufname_match('vendor/*')
  )
end)

local M = {}

function M.setup (on_attach, _)
  require('null-ls').setup {
    -- debug = true,
    diagnostics_format = '#{m} [#{s}]',
    sources = {
      -- builtins.code_actions.gitsigns,

      -- yay -S shellcheck
      builtins.diagnostics.shellcheck,

      -- yay -S lua51-luacheck
      builtins.diagnostics.luacheck,
      -- yay -S stylua-bin
      builtins.formatting.stylua,

      builtins.diagnostics.phpstan.with {
        command = php_command_resolver('phpstan'),
        ---@param params ExtendedNullLsParams
        runtime_condition = should_run(function(params)
          return php_command_resolver('phpstan')(params) and not(
            params.bufname_match('src/Core/Infrastructure/Migrations/*')
            or params.bufname_match('src/**/spec/*')
            or params.bufname_match('src/**/DataFixtures/*')
            or params.bufname_match('src/**/Behat/*')
            or params.bufname_match('vendor/*')
          )
        end),
      },

      builtins.formatting.phpcbf.with {
        command = php_command_resolver('phpcbf'),
        runtime_condition = function(params)
          return php_command_resolver('phpcbf')(params) and should_run_phpcs(params)
        end,
      },
      builtins.diagnostics.phpcs.with {
        command = php_command_resolver('phpcs'),
        runtime_condition = function(params)
          return php_command_resolver('phpcs')(params) and should_run_phpcs(params)
        end,
      },

      builtins.formatting.phpcsfixer.with {
        command = php_command_resolver('php-cs-fixer'),
        runtime_condition = should_run_phpcsfixer,
      },
      phpcsfixer.with {
        command = php_command_resolver('php-cs-fixer'),
        runtime_condition = should_run_phpcsfixer,
      },
    },
    on_attach = on_attach,
  }
end

return M
