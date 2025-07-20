local ensure_lazy_is_installed = function()
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
        { out, 'WarningMsg' },
        { '\nPress any key to exit...' },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end

  vim.opt.rtp:prepend(lazypath)
end

ensure_lazy_is_installed()

require('lazy').setup({
  spec = {
    { import = 'cdejoye.plugins' },

    -- -- I keep it around for now, it's interesting. It was easy to setup and more powerful than projectionist
    -- -- The mappings are actually stored in a `g:` vim variable
    -- -- So there should be a way to init the list on a per project basis
    -- { -- Alternative to projectionist
    --   'otavioschwanck/telescope-alternate',
    --   requires = 'nvim-telescope/telescope.nvim',
    --   opts = {
    --     open_only_one_with = 'vertical_split',
    --     mappings = {
    --       {
    --         'src/Planner/([^/]*)/(.*).php',
    --         {
    --           { 'tests/Planner/[1]/Unit/[2]Test.php', 'Unit test' },
    --           { 'tests/Planner/[1]/Integration/[2]Test.php', 'Integration test' },
    --           { 'tests/Planner/[1]/Acceptance/[2]Test.php', 'Acceptance test' },
    --         },
    --       },
    --       {
    --         'tests/Planner/([^/]*)/[^/]*/(.*)Test.php', -- The middle one is in replacement of: Unit|Integration|Acceptance
    --         { { 'src/Planner/[1]/[2].php', 'Source' } },
    --       },
    --     },
    --   },
    --   config = function (plugin, opts)
    --     require(plugin.name).setup(opts)
    --     require('telescope').load_extension(plugin.name)
    --   end,
    -- },
  },
  checker = { enabled = true },
  dev = {
    path = '~/work/nvim-plugins',
  },
})
