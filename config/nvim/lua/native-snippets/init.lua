--- Native snippets cmp source
local source = {}

local completion_provider = require('native-snippets.completion_provider')

--- Get debug name for cmp source
--- @return string
function source:get_debug_name()
  return 'native_snippets'
end

--- Complete function for cmp integration
--- @param request table The completion request from cmp
--- @param callback function Callback to return completion items
function source:complete(request, callback)
  local filetype = vim.bo.filetype
  local items = completion_provider.get_items_for_filetype(filetype)

  callback({ items = items })
end

return source

