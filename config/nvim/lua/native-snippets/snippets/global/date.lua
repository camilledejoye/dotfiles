--- PHP date snippet
local M = {}

--- Generate a date snippet with current date
--- @return table LSP completion item for current date
function M.create()
  return {
    label = 'n_date',
    insertText = os.date('%Y-%m-%d'),
    insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
    kind = vim.lsp.protocol.CompletionItemKind.Snippet,
  }
end

return M
