local assert = require('luassert')

-- Minimal vim API mocking
if not _G.vim then
  _G.vim = {
    lsp = {
      protocol = {
        CompletionItemKind = { Snippet = 15 },
        InsertTextFormat = { Snippet = 2, PlainText = 1 }
      }
    }
  }
end

describe('CompletionProvider', function()
  local CompletionProvider = require('native-snippets.completion_provider')
  
  describe('get_items_for_filetype', function()
    it('should return empty table for unsupported filetypes', function()
      local items = CompletionProvider.get_items_for_filetype('unknown')
      assert.equals(0, #items)
    end)
    
    it('should return completion items for php', function()
      local items = CompletionProvider.get_items_for_filetype('php')
      assert.is_true(#items > 0)
    end)
  end)
  
  describe('completion item structure', function()
    it('should have required LSP completion fields', function()
      local items = CompletionProvider.get_items_for_filetype('php')
      local item = items[1]
      
      -- Test the contract our cmp source expects
      assert.is_string(item.label)
      assert.is_string(item.insertText)
      assert.equals('number', type(item.insertTextFormat))
      assert.equals('number', type(item.kind))
    end)
  end)
end)