--- PHP method snippet
local M = {}

---@enum Visibility
local Visibility = {
  PUBLIC = 'public',
  PROTECTED = 'protected',
  PRIVATE = 'private',
}

--- Helper function to generate method snippet completion item
--- @param label string The snippet label (e.g., 'n_mu', 'n_mus')
--- @param visibility Visibility The method visibility enum value
--- @param opts? table Optional modifiers { static = boolean, abstract = boolean, interface = boolean }
--- @return table LSP completion item
local function create_method_snippet(label, visibility, opts)
  opts = opts or {}

  local modifiers = {}
  if opts.abstract then
    table.insert(modifiers, 'abstract')
  end
  if opts.static then
    table.insert(modifiers, 'static')
  end

  local modifier_str = #modifiers > 0 and (table.concat(modifiers, ' ') .. ' ') or ''
  local body = opts.interface and ';' or '\n{\n\t$0\n}'

  return {
    label = label,
    insertText = string.format('%s %sfunction ${1:name}($2): ${3:void}%s', visibility, modifier_str, body),
    insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
    kind = vim.lsp.protocol.CompletionItemKind.Snippet,
  }
end

--- Generate a method snippet with visibility choice (experimental)
--- @return table LSP completion item for PHP method with choice placeholder
function M.method_choice()
  return {
    label = 'n_method_choice',
    insertText = '${1|public,protected,private|} function ${2:name}($3): ${4:void}\n{\n\t$0\n}',
    insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
    kind = vim.lsp.protocol.CompletionItemKind.Snippet,
  }
end

--- Generate a public method snippet (n_mu - method public)
--- @return table LSP completion item for PHP public method
function M.method_public()
  return create_method_snippet('n_mu', Visibility.PUBLIC)
end

--- Generate a protected method snippet (n_mo - method protected)
--- @return table LSP completion item for PHP protected method
function M.method_protected()
  return create_method_snippet('n_mo', Visibility.PROTECTED)
end

--- Generate a private method snippet (n_mi - method private)
--- @return table LSP completion item for PHP private method
function M.method_private()
  return create_method_snippet('n_mi', Visibility.PRIVATE)
end

--- Generate a public static method snippet (n_mus - method public static)
--- @return table LSP completion item for PHP public static method
function M.method_public_static()
  return create_method_snippet('n_mus', Visibility.PUBLIC, { static = true })
end

--- Generate a protected static method snippet (n_mos - method protected static)
--- @return table LSP completion item for PHP protected static method
function M.method_protected_static()
  return create_method_snippet('n_mos', Visibility.PROTECTED, { static = true })
end

--- Generate a private static method snippet (n_mis - method private static)
--- @return table LSP completion item for PHP private static method
function M.method_private_static()
  return create_method_snippet('n_mis', Visibility.PRIVATE, { static = true })
end

return M
