--- PHP constructor snippets with different visibilities
local M = {}

--- Helper function to create constructor snippet with specific visibility
--- @param label string The completion label
--- @param visibility string The visibility keyword (public, protected, private)
--- @return table LSP completion item for PHP constructor
local function create_constructor(label, visibility)
  return {
    label = label,
    insertText = visibility .. ' function __construct($1)\n{\n\t$0\n}',
    insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
    kind = vim.lsp.protocol.CompletionItemKind.Snippet,
  }
end

--- Generate a public constructor snippet (n_cu)
--- @return table LSP completion item for public PHP constructor
function M.public()
  return create_constructor('n_cu', 'public')
end

--- Generate a protected constructor snippet (n_co)
--- @return table LSP completion item for protected PHP constructor
function M.protected()
  return create_constructor('n_co', 'protected')
end

--- Generate a private constructor snippet (n_ci)
--- @return table LSP completion item for private PHP constructor
function M.private()
  return create_constructor('n_ci', 'private')
end

return M
