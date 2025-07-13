--- Provides completion items for native snippets
local M = {}

-- Global snippet modules
local global_date = require('native-snippets.snippets.global.date')

-- PHP snippet modules
local php_construct = require('native-snippets.snippets.php.construct')
local php_function = require('native-snippets.snippets.php.function')
local php_method = require('native-snippets.snippets.php.method')
local php_class = require('native-snippets.snippets.php.class')

--- Get completion items for a specific filetype
--- @param filetype string The filetype to get snippets for
--- @return table List of LSP completion items
function M.get_items_for_filetype(filetype)
  -- Global snippets available for all filetypes
  local items = {
    global_date.create_date(),
    global_date.create_datetime(),
  }

  -- Add language-specific snippets
  if filetype == 'php' then
    vim.list_extend(items, {
      php_construct.create_public(),
      php_construct.create_protected(),
      php_construct.create_private(),
      php_function.create(),
      php_method.create(),
      php_class.create(),
    })
  end

  return items
end

return M
