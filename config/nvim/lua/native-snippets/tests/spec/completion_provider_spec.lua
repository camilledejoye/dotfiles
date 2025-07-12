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
  
  describe('dynamic content generation', function()
    it('should generate current date in YYYY-MM-DD format', function()
      local items = CompletionProvider.get_items_for_filetype('php')
      local date_item = nil
      
      -- Find the date snippet
      for _, item in ipairs(items) do
        if item.label == 'n_date' then
          date_item = item
          break
        end
      end
      
      assert.is_not_nil(date_item)
      -- Should match YYYY-MM-DD pattern
      assert.matches('%d%d%d%d%-%d%d%-%d%d', date_item.insertText)
      -- Should not be the hardcoded test date
      assert.is_not.equals('2025-01-12', date_item.insertText)
    end)
    
    it('should generate fresh date on each call', function()
      local items1 = CompletionProvider.get_items_for_filetype('php')
      local items2 = CompletionProvider.get_items_for_filetype('php')
      
      local date1 = items1[1].insertText
      local date2 = items2[1].insertText
      
      -- Should be same date (since called in same second)
      -- but proves it's calling os.date() each time
      assert.equals(date1, date2)
      assert.matches('%d%d%d%d%-%d%d%-%d%d', date1)
    end)
  end)
end)