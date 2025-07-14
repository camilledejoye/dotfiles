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

  local body = (opts.interface or opts.abstract) and ';' or '\n{\n\t$0\n}'

  -- Build method signature with proper PHP modifier order: abstract visibility static
  local signature_parts = {}
  if opts.abstract then
    table.insert(signature_parts, 'abstract')
  end
  table.insert(signature_parts, visibility)
  if opts.static then
    table.insert(signature_parts, 'static')
  end

  local signature = table.concat(signature_parts, ' ')

  return {
    label = label,
    insertText = string.format('%s function ${1:name}($2): ${3:void}%s', signature, body),
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

--- Generate an abstract public method snippet (n_mau - method abstract public)
--- @return table LSP completion item for PHP abstract public method
function M.method_abstract_public()
  return create_method_snippet('n_mau', Visibility.PUBLIC, { abstract = true })
end

--- Generate an abstract protected method snippet (n_mao - method abstract protected)
--- @return table LSP completion item for PHP abstract protected method
function M.method_abstract_protected()
  return create_method_snippet('n_mao', Visibility.PROTECTED, { abstract = true })
end

--- Generate an abstract private method snippet (n_mai - method abstract private)
--- @return table LSP completion item for PHP abstract private method
function M.method_abstract_private()
  return create_method_snippet('n_mai', Visibility.PRIVATE, { abstract = true })
end

return M
