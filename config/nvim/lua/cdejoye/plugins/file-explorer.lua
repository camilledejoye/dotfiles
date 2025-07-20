--- @module lazy
--- @type LazySpec
return {
  'tamago324/lir.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'tamago324/lir-bookmark.nvim',
  },
  config = function()
    -- Should not be there but not sure I'll keep the plugin
    -- So I play lazy and keep the config file on the side for now
    require('cdejoye.config.lir')
  end,
  keys = {
    {
      '-',
      [[:edit <C-r>=expand('%:p:h')<CR><CR>]],
      desc = 'Open folder of current file in current buffer',
      noremap = false,
      silent = true,
    },
  },
}
