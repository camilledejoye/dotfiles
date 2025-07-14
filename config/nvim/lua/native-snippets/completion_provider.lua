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
    global_date.date(),
    global_date.datetime(),
  }

  -- Add language-specific snippets
  if filetype == 'php' then
    vim.list_extend(items, {
      php_construct.public(),
      php_construct.protected(),
      php_construct.private(),
      php_function.func(),
      php_method.method_choice(), -- Experimental choice snippet
      php_method.method_public(), -- n_mu - public method
      php_method.method_protected(), -- n_mo - protected method
      php_method.method_private(), -- n_mi - private method
      php_method.method_public_static(), -- n_mus - public static method
      php_method.method_protected_static(), -- n_mos - protected static method
      php_method.method_private_static(), -- n_mis - private static method
      php_method.method_abstract_public(), -- n_mau - abstract public method
      php_method.method_abstract_protected(), -- n_mao - abstract protected method
      php_method.method_abstract_private(), -- n_mai - abstract private method
      php_class.class(),
    })
  end

  return items
end

return M
