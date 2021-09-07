local Tab = require('lualine.components.tab')
local TabList = require('lualine.components.windows'):new()

function TabList:get_win_list()
  local tabs = vim.api.nvim_list_tabpages()
  local windows = {}

  if 1 == #tabs then -- Don't list the tabs if there is only one
    return {}
  end

  for _, tabnr in ipairs(tabs) do
    table.insert(windows, vim.api.nvim_tabpage_get_win(tabnr))
  end

  return windows
end

function TabList:create_window(winnr)
  local tab_options = vim.tbl_extend('force', self.options, {
    'tab',
    component_name = 'tab',
  })

  return Tab:new(tab_options, Tab, winnr)
end

return TabList
