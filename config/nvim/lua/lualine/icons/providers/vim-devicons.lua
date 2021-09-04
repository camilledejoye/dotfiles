local IconsProvider = require('lualine.icons.providers.abstract')

---Implementation using vim-devicons
---@class VimWebDevIconsProvider : IconsProvider
local VimWebDevIconsProvider = IconsProvider:new()

function VimWebDevIconsProvider:is_available()
  return 0 ~= vim.fn.exists('*WebDevIconsGetFileTypeSymbol')
end

function VimWebDevIconsProvider:for_filename(filename)
  local extension = self:extension(filename)

  return vim.fn.WebDevIconsGetFileTypeSymbol(filename, extension)
end

return VimWebDevIconsProvider
