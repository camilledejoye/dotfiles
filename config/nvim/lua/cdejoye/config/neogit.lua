require('neogit').setup({
  disable_commit_confirmation = true,
  integrations = {
    diffview = true,
  },
  -- override/add mappings
  mappings = {
    -- modify status buffer mappings
    status = {
      ["za"] = "Toggle",
      ["zR"] = "Depth4",
    }
  },
})

require('cdejoye.utils').map('<Leader>gs', '<cmd>Neogit<CR>', 'n')
