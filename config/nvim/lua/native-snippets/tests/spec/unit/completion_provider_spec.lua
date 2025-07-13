---@diagnostic disable: undefined-global
---@diagnostic disable: need-check-nil
local assert = require('luassert')
local describe = require('plenary.busted').describe
local it = require('plenary.busted').it

-- Minimal vim API mocking
if not _G.vim then
  _G.vim = {
    lsp = {
      protocol = {
        CompletionItemKind = { Snippet = 15 },
        InsertTextFormat = { Snippet = 2, PlainText = 1 },
      },
    },
  }
end

describe('CompletionProvider', function()
  local CompletionProvider = require('native-snippets.completion_provider')

  describe('get_items_for_filetype', function()
    it('should return global snippets for all filetypes', function()
      local items = CompletionProvider.get_items_for_filetype('javascript')
      assert.equals(1, #items) -- Should have date snippet
      assert.equals('n_date', items[1].label)
    end)

    it('should return global + PHP snippets for php filetype', function()
      local items = CompletionProvider.get_items_for_filetype('php')
      assert.equals(5, #items) -- 1 global + 4 PHP snippets
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

  describe('snippet availability', function()
    it('should include all expected PHP snippets', function()
      local items = CompletionProvider.get_items_for_filetype('php')
      local labels = {}

      for _, item in ipairs(items) do
        table.insert(labels, item.label)
      end

      -- Check that expected snippets are present
      assert.is_true(vim.tbl_contains(labels, 'n_date'), 'should include n_date snippet')
      assert.is_true(vim.tbl_contains(labels, 'n_construct'), 'should include n_construct snippet')
      assert.is_true(vim.tbl_contains(labels, 'n_function'), 'should include n_function snippet')
      assert.is_true(vim.tbl_contains(labels, 'n_method'), 'should include n_method snippet')
      assert.is_true(vim.tbl_contains(labels, 'n_class'), 'should include n_class snippet')
    end)
  end)
end)
