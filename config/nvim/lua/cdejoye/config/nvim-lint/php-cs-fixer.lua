
local processors = require('cdejoye.config.nvim-lint.processors')
local php_cs_fixer = require('cdejoye.config.nvim-lint.linters.php-cs-fixer')

return require('lint.util').wrap(php_cs_fixer, function(diagnostic)
  return processors.apply_format(diagnostic)
end)
