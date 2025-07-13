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

return M
