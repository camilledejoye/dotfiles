--- @module lazy
--- @type LazySpec
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@module "snacks"
  ---@type snacks.Config
  opts = {
    input = { enabled = true, win = { relative = 'cursor' } },
    lazygit = { enabled = true },
  },
  keys = {
    {
      '<Leader>lg',
      function()
        require('snacks').lazygit()
      end,
      desc = 'Open lazygit in a float window',
    }
  }
}
