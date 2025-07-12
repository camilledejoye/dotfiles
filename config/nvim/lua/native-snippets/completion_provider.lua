--- Provides completion items for native snippets
local M = {}

-- PHP snippet modules
local php_date = require('native-snippets.snippets.php.date')
local php_construct = require('native-snippets.snippets.php.construct')

--- Get completion items for a specific filetype
--- @param filetype string The filetype to get snippets for
--- @return table List of LSP completion items
function M.get_items_for_filetype(filetype)
  if filetype ~= 'php' then
    return {}
  end

  return {
    php_date.create(),
    php_construct.create(),
  }
end

return M
