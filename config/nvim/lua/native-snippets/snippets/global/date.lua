--- Global date and datetime snippets
local M = {}

--- Generate a date snippet with current date
--- @return table LSP completion item for current date
function M.date()
  return {
    label = 'n_date',
    insertText = os.date('%Y-%m-%d'),
    insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
    kind = vim.lsp.protocol.CompletionItemKind.Snippet,
  }
end

--- Generate a datetime snippet with current date and time
--- @return table LSP completion item for current datetime
function M.datetime()
  return {
    label = 'n_datetime',
    insertText = os.date('%Y-%m-%d %H:%M:%S'),
    insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
    kind = vim.lsp.protocol.CompletionItemKind.Snippet,
  }
end

return M
