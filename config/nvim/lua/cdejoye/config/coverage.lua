local coverage = require('coverage')

-- Setup
local function find_coverage_file()
  for _, file in ipairs({'coverage/cobertura.xml', 'var/coverage/phpspec/cobertura.xml'}) do
    if nil ~= vim.loop.fs_stat(file) then
      return file
    end
  end

  return 'cobertura.xml'
end

coverage.setup({
  commands = true, -- create commands
  auto_reload = true,
  lang = {
    php = {
      coverage_file = find_coverage_file(),
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
