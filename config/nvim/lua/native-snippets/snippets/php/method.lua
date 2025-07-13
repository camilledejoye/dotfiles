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

--- Generate a public method snippet (n_mu - method public)
--- @return table LSP completion item for PHP public method
function M.method_public()
  return {
    label = 'n_mu',
    insertText = 'public function ${1:name}($2): ${3:void}\n{\n\t$0\n}',
    insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
    kind = vim.lsp.protocol.CompletionItemKind.Snippet,
  }
end

--- Generate a protected method snippet (n_mo - method protected)
--- @return table LSP completion item for PHP protected method
function M.method_protected()
  return {
    label = 'n_mo',
    insertText = 'protected function ${1:name}($2): ${3:void}\n{\n\t$0\n}',
    insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
    kind = vim.lsp.protocol.CompletionItemKind.Snippet,
  }
end

--- Generate a private method snippet (n_mi - method private)
--- @return table LSP completion item for PHP private method
function M.method_private()
  return {
    label = 'n_mi',
    insertText = 'private function ${1:name}($2): ${3:void}\n{\n\t$0\n}',
    insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
    kind = vim.lsp.protocol.CompletionItemKind.Snippet,
  }
end

return M
