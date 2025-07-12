--- Provides completion items for native snippets
local M = {}

--- Get completion items for a specific filetype
--- @param filetype string The filetype to get snippets for
--- @return table List of LSP completion items
function M.get_items_for_filetype(filetype)
  if filetype ~= 'php' then
    return {}
  end
  
  return {
    {
      label = 'n_date',
      insertText = '2025-01-12',
      insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
      kind = vim.lsp.protocol.CompletionItemKind.Snippet
    }
  }
end

return M