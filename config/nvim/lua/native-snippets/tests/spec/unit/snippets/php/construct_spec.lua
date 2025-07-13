---@diagnostic disable: undefined-global
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

describe('PHP constructor snippets', function()
  local construct_snippet = require('native-snippets.snippets.php.construct')

  describe('n_cu (public constructor)', function()
    it('should provide n_cu completion item', function()
      local item = construct_snippet.create_public()

      assert.equals('n_cu', item.label)
      assert.is_string(item.insertText)
      assert.equals(vim.lsp.protocol.CompletionItemKind.Snippet, item.kind)
      assert.equals(vim.lsp.protocol.InsertTextFormat.Snippet, item.insertTextFormat)
    end)

    it('should contain public PHP constructor method', function()
      local item = construct_snippet.create_public()

      assert.is_true(string.find(item.insertText, '__construct') ~= nil, 'should contain __construct method')
      assert.is_true(string.find(item.insertText, 'public function') ~= nil, 'should be a public function')
    end)

    it('should provide parameter placeholder and cursor positioning', function()
      local item = construct_snippet.create_public()

      assert.is_true(string.find(item.insertText, '%$1') ~= nil, 'should have $1 placeholder for parameters')
      assert.is_true(string.find(item.insertText, '%$0') ~= nil, 'should have $0 placeholder for final cursor position')
    end)
  end)

  describe('n_co (protected constructor)', function()
    it('should provide n_co completion item', function()
      local item = construct_snippet.create_protected()

      assert.equals('n_co', item.label)
      assert.is_string(item.insertText)
      assert.equals(vim.lsp.protocol.CompletionItemKind.Snippet, item.kind)
      assert.equals(vim.lsp.protocol.InsertTextFormat.Snippet, item.insertTextFormat)
    end)

    it('should contain protected PHP constructor method', function()
      local item = construct_snippet.create_protected()

      assert.is_true(string.find(item.insertText, '__construct') ~= nil, 'should contain __construct method')
      assert.is_true(string.find(item.insertText, 'protected function') ~= nil, 'should be a protected function')
    end)

    it('should provide parameter placeholder and cursor positioning', function()
      local item = construct_snippet.create_protected()

      assert.is_true(string.find(item.insertText, '%$1') ~= nil, 'should have $1 placeholder for parameters')
      assert.is_true(string.find(item.insertText, '%$0') ~= nil, 'should have $0 placeholder for final cursor position')
    end)
  end)

  describe('n_ci (private constructor)', function()
    it('should provide n_ci completion item', function()
      local item = construct_snippet.create_private()

      assert.equals('n_ci', item.label)
      assert.is_string(item.insertText)
      assert.equals(vim.lsp.protocol.CompletionItemKind.Snippet, item.kind)
      assert.equals(vim.lsp.protocol.InsertTextFormat.Snippet, item.insertTextFormat)
    end)

    it('should contain private PHP constructor method', function()
      local item = construct_snippet.create_private()

      assert.is_true(string.find(item.insertText, '__construct') ~= nil, 'should contain __construct method')
      assert.is_true(string.find(item.insertText, 'private function') ~= nil, 'should be a private function')
    end)

    it('should provide parameter placeholder and cursor positioning', function()
      local item = construct_snippet.create_private()

      assert.is_true(string.find(item.insertText, '%$1') ~= nil, 'should have $1 placeholder for parameters')
      assert.is_true(string.find(item.insertText, '%$0') ~= nil, 'should have $0 placeholder for final cursor position')
    end)
  end)
end)
