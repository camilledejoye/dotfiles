--- PHP function snippet
local M = {}

--- Generate a function snippet
--- @return table LSP completion item for PHP function
function M.create()
  return {
    label = 'n_function',
    insertText = 'function $1($2)\n{\n\t$0\n}',
    insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
    kind = vim.lsp.protocol.CompletionItemKind.Snippet,
  }
end

return M

