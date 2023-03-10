local coverage = require('coverage')
local config = require('cdejoye.config').coverage

-- Setup
coverage.setup({
  commands = true, -- create commands
  auto_reload = true,
  lang = {
    php = {
      coverage_file = config.php.coverage_file,
      path_mappings = {
        -- Keeps empty to use relative paths
        ['/var/www/html/'] = '',
      },
    },
  },
  signs = {
    covered = { text = '┃' },
    uncovered = { text = '┃' },
  },
})

-- Theming
local hi = require('cdejoye.utils').hi
hi('CoverageCovered', 'DiffAdd')
hi('CoverageUncovered', '@error')
hi('CoveragePartial', '@conditional')

-- Mappings
local map = require('cdejoye.utils').map
map('<leader>tc', coverage.toggle)
map('<leader>tC', function() coverage.load(true) end)
