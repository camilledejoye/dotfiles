--- Native snippets cmp source
local source = {}

local completion_provider = require('native-snippets.completion_provider')

--- Get debug name for cmp source
--- @return string
function source:get_debug_name(_) -- luacheck: ignore 212
  return 'native_snippets'
end

--- Complete function for cmp integration
--- @param _ table The completion request from cmp (unused)
--- @param callback function Callback to return completion items
function source:complete(_, callback) -- luacheck: ignore 212
  local filetype = vim.bo.filetype
  local items = completion_provider.get_items_for_filetype(filetype)

  callback({ items = items })
end

return source
