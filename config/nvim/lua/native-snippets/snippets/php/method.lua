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
--- @return lsp.CompletionItem LSP completion item
--- @usage
--- local snippet = create_method_snippet('n_mu', Visibility.PUBLIC)
--- local static_snippet = create_method_snippet('n_mus', Visibility.PUBLIC, { static = true })
--- local abstract_snippet = create_method_snippet('n_mau', Visibility.PUBLIC, { abstract = true })
--- local abstract_static_snippet = create_method_snippet('n_masu', Visibility.PUBLIC, { static = true, abstract = true })
--- local interface_snippet = create_method_snippet('n_m;u', Visibility.PUBLIC, { interface = true })
local function create_method_snippet(label, visibility, opts)
  opts = opts or {}

  -- Interface methods are always public in PHP
  if opts.interface then
    visibility = Visibility.PUBLIC
    -- Interface methods cannot be abstract (redundant)
    opts.abstract = false
  end

  -- Build method declaration: abstract? visibility static?
  local declaration_parts = {}
  if opts.abstract then
    table.insert(declaration_parts, 'abstract')
  end
  table.insert(declaration_parts, visibility)
  if opts.static then
    table.insert(declaration_parts, 'static')
  end

  local body = (opts.interface or opts.abstract) and ';' or '\n{\n\t$0\n}'

  return {
    label = label,
    insertText = string.format('%s function ${1:name}($2): ${3:void}%s', table.concat(declaration_parts, ' '), body),
    insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
    kind = vim.lsp.protocol.CompletionItemKind.Snippet,
  }
end

--- Generate a method snippet with visibility choice (experimental)
--- @return lsp.CompletionItem LSP completion item for PHP method with choice placeholder
function M.method_choice()
  return {
    label = 'n_method_choice',
    insertText = '${1|public,protected,private|} function ${2:name}($3): ${4:void}\n{\n\t$0\n}',
    insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
    kind = vim.lsp.protocol.CompletionItemKind.Snippet,
  }
end

-- Simple table of all method snippet configurations
local method_snippets = {
  { label = 'n_mu', visibility = Visibility.PUBLIC },
  { label = 'n_mo', visibility = Visibility.PROTECTED },
  { label = 'n_mi', visibility = Visibility.PRIVATE },
  { label = 'n_mus', visibility = Visibility.PUBLIC, static = true },
  { label = 'n_mos', visibility = Visibility.PROTECTED, static = true },
  { label = 'n_mis', visibility = Visibility.PRIVATE, static = true },
  { label = 'n_mau', visibility = Visibility.PUBLIC, abstract = true },
  { label = 'n_mao', visibility = Visibility.PROTECTED, abstract = true },
  { label = 'n_masu', visibility = Visibility.PUBLIC, static = true, abstract = true },
  { label = 'n_maso', visibility = Visibility.PROTECTED, static = true, abstract = true },
  { label = 'n_m;u', visibility = Visibility.PUBLIC, interface = true },
  { label = 'n_m;us', visibility = Visibility.PUBLIC, static = true, interface = true },
}

--- Generate all method snippets from simple table configuration
--- @return lsp.CompletionItem[] List of LSP completion items
--- @usage
--- local snippets = M.generate_all_snippets()
--- -- Returns array of completion items for: n_mu, n_mo, n_mi, n_mus, n_mos, n_mis, n_mau, n_mao, n_masu, n_maso, n_m;u, n_m;us
function M.generate_all_snippets()
  local snippets = {}
  for _, config in ipairs(method_snippets) do
    local snippet = create_method_snippet(config.label, config.visibility, {
      static = config.static,
      abstract = config.abstract,
      interface = config.interface,
    })
    table.insert(snippets, snippet)
  end
  return snippets
end

return M
