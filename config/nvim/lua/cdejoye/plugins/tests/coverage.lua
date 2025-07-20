--- @module lazy
--- @type LazySpec
return {
  'andythigpen/nvim-coverage',
  dependencies = 'nvim-lua/plenary.nvim',
  rocks = { 'lua-xmlreader' },
  opts = {
    commands = true, -- create commands
    auto_reload = true,
    lang = {
      php = {
        coverage_file = 'coverage/cobertura.xml',
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
  },
  config = function(_, opts)
    local coverage = require('coverage')

    -- Setup
    coverage.setup(opts)

    -- Theming
    local hi = require('cdejoye.utils').hi
    hi('CoverageCovered', 'DiffAdd')
    hi('CoverageUncovered', '@error')
    hi('CoveragePartial', '@conditional')
  end,
  cmd = {
    'Coverage',
    'CoverageHide',
    'CoverageLoad',
    'CoverageShow',
    'CoverageClear',
    'CoverageToggle',
    'CoverageSummary',
  },
  keys = {
    {
      '<leader>tc',
      function()
        require('coverage').toggle()
      end,
      desc = 'Toggle code coverage',
    },
    {
      '<leader>tC',
      function()
        require('coverage').load(true)
      end,
      desc = "Load a coverage report but doesn't put any signs",
    },
  },
}
