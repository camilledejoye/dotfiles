local IconsProvider = require('lualine.icons.providers.abstract')

---Implementation using `nvim-web-devicons` plugin
---@class NvimWebDevIconsProvider : IconsProvider
local NvimWebDevIconsProvider = IconsProvider:new()

function NvimWebDevIconsProvider:is_available()
  local ok = pcall(require, 'nvim-web-devicons')

  return ok -- Return separately to not include the module (2nd return value from pcall)
end

function NvimWebDevIconsProvider:for_filename(filename)
  local extension = self:extension(filename)

  return require('nvim-web-devicons').get_icon(filename, extension)
end

return NvimWebDevIconsProvider
