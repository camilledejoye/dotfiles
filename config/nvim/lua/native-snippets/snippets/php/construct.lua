--- PHP constructor snippet
local M = {}

--- Generate a constructor snippet
--- @return table LSP completion item for PHP constructor
function M.create()
  return {
    label = 'n_construct',
    insertText = 'public function __construct($1)\n{\n\t$0\n}',
    insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
    kind = vim.lsp.protocol.CompletionItemKind.Snippet,
  }
end

return M