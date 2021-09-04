local IconsProvider = require('lualine.icons.providers.abstract')

---Implementation used to always return a provider, even when no implementations are
--available
---@class NullIconsProvider : IconsProvider
local NullIconsProvider = IconsProvider:new()

function NullIconsProvider:is_available()
  return true
end

---@diagnostic disable-next-line:unused-local
function NullIconsProvider:for_filename(filename)
  return nil, nil
end

return NullIconsProvider
