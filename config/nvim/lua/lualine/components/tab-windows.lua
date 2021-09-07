local TabWindows = require('lualine.components.windows'):new()

function TabWindows:get_win_list()
  local tabnr = vim.api.nvim_get_current_tabpage()

  return vim.api.nvim_tabpage_list_wins(tabnr)
end

return TabWindows
