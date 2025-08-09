local linters = require('lint').linters
local utils = require('cdejoye.utils')
local processors = require('cdejoye.config.nvim-lint.processors')
local phpstan = linters.phpstan --[[@as lint.Linter]]

-- Select the first executable, in order, found in the PATH:
-- * phpstan
-- * tools/phpstan
-- * tolls/phpstan/vendor/bin/phpstan
-- * vendor/bin/phpstan
phpstan.cmd = utils.find_executable('phpstan', {
  'tools',
  'tools/phpstan/vendor/bin',
  'vendor/bin',
})

-- Always run for the full project, cache make it as fast as on one file (outside of first run)
-- Without this we don't actually parse traits because when providing a file to analyze phpstan doesn't load
-- the traits used in it: https://phpstan.org/blog/how-phpstan-analyses-traits
phpstan.append_fname = false

table.insert(phpstan.args, '--memory-limit=-1')

-- phpstan default parser doesn't correctly define the diagnostic
-- this prevent neovim from underlining it correctly
local new_linter = require('lint.util').wrap(phpstan, function(diagnostic)
  return processors.apply_format(processors.ensure_underline(diagnostic))
end)

-- Return a function to delay the resolution of cwd
-- This way we run phpstan in the folder containing the config file for the current buffer
return function()
  new_linter.cwd = vim.fs.root(0, {
    {'phpstan.neon'}, -- Look for local config file first
    {'phpstan.neon.dist', 'phpstan.dist.neon'}, -- Look for project config file otherwise
  })
  return new_linter
end

