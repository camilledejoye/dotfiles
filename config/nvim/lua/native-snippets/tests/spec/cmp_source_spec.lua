---@diagnostic disable: undefined-global
---@diagnostic disable: need-check-nil
local assert = require('luassert')

-- Mock vim API for testing
_G.vim = _G.vim or {}
_G.vim.bo = _G.vim.bo or {}
_G.vim.bo.filetype = 'php'
_G.vim.lsp = _G.vim.lsp
  or {
    protocol = {
      CompletionItemKind = { Snippet = 15 },
      InsertTextFormat = { Snippet = 2, PlainText = 1 },
    },
  }

describe('NativeSnippets cmp source', function()
  local source = require('native-snippets')

  describe('cmp source interface', function()
    it('should be a valid cmp source', function()
      assert.is_function(source.complete)
      assert.is_function(source.get_debug_name)
    end)

    it('should return correct debug name', function()
      local debug_name = source.get_debug_name()
      assert.equals('native_snippets', debug_name)
    end)
  end)

  describe('completion behavior', function()
    it('should call completion provider and return items via callback', function()
      local callback_called = false
      local callback_result = nil

      local callback = function(result)
        callback_called = true
        callback_result = result
      end

      source.complete({}, callback)

      assert.is_true(callback_called)
      assert.is_table(callback_result)
      assert.is_table(callback_result.items)
      assert.is_true(#callback_result.items > 0)
    end)

    it('should return properly formatted cmp completion items', function()
      local callback_result = nil

      source.complete({}, function(result)
        callback_result = result
      end)

      local item = callback_result.items[1]
      assert.is_string(item.label)
      assert.is_string(item.insertText)
      assert.is_number(item.insertTextFormat)
      assert.is_number(item.kind)
    end)
  end)

  describe('filetype filtering', function()
    it('should respect current buffer filetype', function()
      -- Test with PHP filetype
      vim.bo.filetype = 'php'
      local php_result = nil
      source.complete({}, function(result)
        php_result = result
      end)

      -- Test with unsupported filetype
      vim.bo.filetype = 'javascript'
      local js_result = nil
      source.complete({}, function(result)
        js_result = result
      end)

      assert.is_true(#php_result.items > 0)
      assert.equals(0, #js_result.items)

      -- Reset to PHP for other tests
      vim.bo.filetype = 'php'
    end)
  end)
end)

