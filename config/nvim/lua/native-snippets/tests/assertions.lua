-- Custom assertions for native snippets testing
local M = {}

-- Register snippet assertion with luassert
function M.register()
  local assert = require('luassert')

  assert:register('assertion', 'snippet', function(state, arguments)
    local expected_label = arguments[1]
    local item = arguments[2]

    -- Check each condition and provide specific error messages
    if item.label ~= expected_label then
      state.failure_message =
        string.format("Expected snippet label '%s' but got '%s'", expected_label, tostring(item.label))
      return false
    end

    if type(item.insertText) ~= 'string' then
      state.failure_message = string.format('Expected insertText to be a string but got %s', type(item.insertText))
      return false
    end

    if item.kind ~= vim.lsp.protocol.CompletionItemKind.Snippet then
      state.failure_message = string.format(
        'Expected CompletionItemKind.Snippet (%d) but got %s',
        vim.lsp.protocol.CompletionItemKind.Snippet,
        tostring(item.kind)
      )
      return false
    end

    if item.insertTextFormat ~= vim.lsp.protocol.InsertTextFormat.Snippet then
      state.failure_message = string.format(
        'Expected InsertTextFormat.Snippet (%d) but got %s',
        vim.lsp.protocol.InsertTextFormat.Snippet,
        tostring(item.insertTextFormat)
      )
      return false
    end

    return true
  end, { 'assertion', 'snippet' })
end

return M