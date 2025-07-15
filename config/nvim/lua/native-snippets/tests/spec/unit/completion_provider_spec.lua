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
      assert.equals(18, #items) -- 2 global + 16 PHP snippets (choice + visibility + static + abstract variants)
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
      assert.is_true(vim.tbl_contains(labels, 'n_mu'), 'should include n_mu snippet (public method)')
      assert.is_true(vim.tbl_contains(labels, 'n_mo'), 'should include n_mo snippet (protected method)')
      assert.is_true(vim.tbl_contains(labels, 'n_mi'), 'should include n_mi snippet (private method)')
      assert.is_true(vim.tbl_contains(labels, 'n_mus'), 'should include n_mus snippet (public static method)')
      assert.is_true(vim.tbl_contains(labels, 'n_mos'), 'should include n_mos snippet (protected static method)')
      assert.is_true(vim.tbl_contains(labels, 'n_mis'), 'should include n_mis snippet (private static method)')
      assert.is_true(vim.tbl_contains(labels, 'n_mau'), 'should include n_mau snippet (abstract public method)')
      assert.is_true(vim.tbl_contains(labels, 'n_mao'), 'should include n_mao snippet (abstract protected method)')
      assert.is_true(
        vim.tbl_contains(labels, 'n_masu'),
        'should include n_masu snippet (abstract static public method)'
      )
      assert.is_true(
        vim.tbl_contains(labels, 'n_maso'),
        'should include n_maso snippet (abstract static protected method)'
      )
      assert.is_true(vim.tbl_contains(labels, 'n_class'), 'should include n_class snippet')
    end)
  end)
end)
