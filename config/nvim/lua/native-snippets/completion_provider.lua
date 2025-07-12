--- Provides completion items for native snippets
local M = {}

--- Generate a date snippet with current date
--- @return table LSP completion item for current date
local function generate_date_snippet()
  return {
    label = 'n_date',
    insertText = os.date('%Y-%m-%d'),
    insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText,
    kind = vim.lsp.protocol.CompletionItemKind.Snippet
  }
end

--- Get completion items for a specific filetype
--- @param filetype string The filetype to get snippets for
--- @return table List of LSP completion items
function M.get_items_for_filetype(filetype)
  if filetype ~= 'php' then
    return {}
  end
  
  return {
    generate_date_snippet()
  }
end

return M