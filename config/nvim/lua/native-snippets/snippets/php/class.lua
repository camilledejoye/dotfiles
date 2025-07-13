--- PHP class snippet
local M = {}

--- Generate a class snippet
--- @return table LSP completion item for PHP class
function M.create()
  return {
    label = 'n_class',
    insertText = 'class $1\n{\n\t$0\n}',
    insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
    kind = vim.lsp.protocol.CompletionItemKind.Snippet,
  }
end

return M
