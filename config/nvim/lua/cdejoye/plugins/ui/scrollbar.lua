local function setup_colorscheme()
  vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
      local normal_hl = vim.api.nvim_get_hl(0, { name = 'Normal' })
      local search_hl = vim.api.nvim_get_hl(0, { name = 'Search' })
      local scrolllbar_handle = vim.api.nvim_get_hl(0, { name = 'ScrollbarHandle' })

      -- Use Search bg color for search markers and regular bg
      vim.api.nvim_set_hl(0, 'ScrollbarSearch', {
        fg = search_hl.bg,
        bg = normal_hl.bg,
      })
      -- Use Search bg color for search markers and the handle bg
      vim.api.nvim_set_hl(0, 'ScrollbarSearchHandle', {
        fg = search_hl.bg,
        bg = scrolllbar_handle.bg,
      })
    end,
  })

  -- Apply immediately
  vim.schedule(function()
    vim.cmd('doautocmd ColorScheme')
  end)
end

--- @module lazy
--- @type LazySpec
return {
  'petertriho/nvim-scrollbar',
  dependencies = {
    'kevinhwang91/nvim-hlslens', -- optional: for enhanced search
    'lewis6991/gitsigns.nvim', -- Optional: for git integration
  },
  opts = {
    folds = false,
    hide_if_all_visible = false,
    show_in_active_only = false,
    handle = {
      blend = 0,
      hide_if_all_visible = false,
    },
  },
  config = function(_, opts)
    require('scrollbar').setup(opts)

    -- Search results on scrollbar
    require('scrollbar.handlers.search').setup({
      override_lens = function() end,
    })

    -- Git changes on scrollbar
    require('scrollbar.handlers.gitsigns').setup()

    setup_colorscheme()
  end,
}
