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
      local items = CompletionProvider.get_items_for_filetype('any_filetype_for_testing')
      assert.equals(2, #items) -- Should have date and datetime snippets
      assert.equals('n_date', items[1].label)
      assert.equals('n_datetime', items[2].label)
    end)

    it('should return global + PHP snippets for php filetype', function()
      local items = CompletionProvider.get_items_for_filetype('php')
      assert.equals(9, #items) -- 2 global + 7 PHP snippets (including experimental choice)
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
      assert.is_true(vim.tbl_contains(labels, 'n_cu'), 'should include n_cu snippet (public constructor)')
      assert.is_true(vim.tbl_contains(labels, 'n_co'), 'should include n_co snippet (protected constructor)')
      assert.is_true(vim.tbl_contains(labels, 'n_ci'), 'should include n_ci snippet (private constructor)')
      assert.is_true(vim.tbl_contains(labels, 'n_function'), 'should include n_function snippet')
      assert.is_true(vim.tbl_contains(labels, 'n_method'), 'should include n_method snippet')
      assert.is_true(vim.tbl_contains(labels, 'n_class'), 'should include n_class snippet')
    end)
  end)
end)
