--- Provides completion items for native snippets
local M = {}

-- PHP snippet modules
local php_date = require('native-snippets.snippets.php.date')
local php_construct = require('native-snippets.snippets.php.construct')
local php_function = require('native-snippets.snippets.php.function')
local php_method = require('native-snippets.snippets.php.method')

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
    php_function.create(),
    php_method.create(),
  }
end

return M
