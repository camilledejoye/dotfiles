--- @module lazy
--- @type LazySpec
return {
  {
    'RRethy/nvim-base16',
    config = function()
      require('cdejoye.config.colorscheme')
    end,
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- A high number is recommended for colorscheme
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000,
  },
  {
    'navarasu/onedark.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('onedark').setup({
        style = 'darker',
        highlights = {
          WinBar = { bg = 'none' },
          WinBarNC = { bg = 'none' },
        },
      })
      -- Enable theme
      require('onedark').load()
    end,
  },
}
