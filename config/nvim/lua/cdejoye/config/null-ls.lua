local builtins = require('null-ls').builtins
local helpers = require('null-ls.helpers')

--- Fake a linter for php-cs-fixer
--- All the diagnostics will be shown on the first line because we don't have line information
---
--- TODO It might be possible to try to find out lines with errors by scanning the resulted diff but
--- I don't see how to link the diffs to the correct rule so even with this solution I might need
--- to show all errors on each impacted line ?
local phpcsfixer = helpers.make_builtin {
  name = 'php-cs',
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

---@class ExtendedNullLsParams @parent Params
---@field bufname_match fun(glob: string): boolean #Match the bufname against a glob pattern

---@alias ShouldRunCallback fun(params: ExtendedNullLsParams): boolean

--- Decides, at runtime, if a source should be run or not
---
---@param callback ShouldRunCallback #Callback used to determine if the source should be run
---@return fun(params: Params): boolean #Wrapper around `callback` to provide extended params
local function should_run(callback)
  vim.validate({callback = { callback, 'function' }})

  ---@param params Params
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
  return not(
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
        ---@params params ExtendedNullLsParams
        runtime_condition = should_run(function(params)
          return not(
            params.bufname_match('src/Core/Infrastructure/Migrations/*')
            or params.bufname_match('src/**/spec/*')
            or params.bufname_match('src/**/DataFixtures/*')
            or params.bufname_match('src/**/Behat/*')
            or params.bufname_match('vendor/*')
          )
        end),
      },

      builtins.formatting.phpcbf.with { runtime_condition = should_run_phpcs, },
      builtins.diagnostics.phpcs.with { runtime_condition = should_run_phpcs, },

      builtins.formatting.phpcsfixer.with { runtime_condition = should_run_phpcsfixer, },
      phpcsfixer.with { runtime_condition = should_run_phpcsfixer, },
    },
    on_attach = on_attach,
  }
end

return M
