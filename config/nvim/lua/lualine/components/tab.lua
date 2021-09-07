local Tab = require('lualine.components.window'):new()

function Tab:get_number()
  return vim.api.nvim_tabpage_get_number(
    vim.api.nvim_win_get_tabpage(self.winnr)
  )
end

function Tab:update_status()
  local status = self._parent._parent.update_status(self)
  -- The default icon use is always placed first, in this case I want the number first
  local icon = self.options.icon
  self.options.icon = nil

  -- I MUST provide self manually as parameter, otherwise Lua provide `self._parent._parent`
  -- as value for the `self` parameter of `Window:update_status()`.
  return string.format(
    '%%T(%d) %s %s%%T',
    self:get_number(),
    icon,
    status
  )
end

return Tab
