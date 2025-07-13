--- PHP method snippet
local M = {}

--- Generate a method snippet
--- @return table LSP completion item for PHP method
function M.method()
  return {
    label = 'n_method',
    insertText = '${1:public} function ${2:name}($3): ${4:void}\n{\n\t$0\n}',
    insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
    kind = vim.lsp.protocol.CompletionItemKind.Snippet,
  }
end

return M
