local linters = require('lint').linters
local utils = require('cdejoye.utils')
local processors = require('cdejoye.config.nvim-lint.processors')
local phpstan = linters.phpstan

-- -- 2025-01-29: commented because it seems it doesn't work anymore when going through a custom script
-- -- But using vendor/bin/phpstan works
-- phpstan.cmd = function()
--   return utils.find_executable('phpstan', {
--     'tools',
--     'tools/phpstan/vendor/bin',
--     'vendor/bin',
--   })
-- end

-- Disable memory limit, at least needed when using local binary for my current project
table.insert(phpstan.args, '--memory-limit=-1')

return require('lint.util').wrap(phpstan, function(diagnostic)
  return processors.apply_format(
    processors.ensure_underline(diagnostic)
  )
end)

--Kept as an example of usage in case I need my wrapper again
-----@param diagnostic vim.Diagnostic
-----@param bufnr integer
--return require('cdejoye.config.nvim-lint.util').wrap(phpstan, function(diagnostic, bufnr)
--  return processors.apply_format(
--    processors.ensure_underline(
--      processors.set_bufnr_on_diagnostic(diagnostic, bufnr)
--    )
--  )
--end)
