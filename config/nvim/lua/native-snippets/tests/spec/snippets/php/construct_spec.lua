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

describe('PHP constructor snippet', function()
  local construct_snippet = require('native-snippets.snippets.php.construct')
  
  it('should provide n_construct completion item', function()
    local item = construct_snippet.create()
    
    assert.equals('n_construct', item.label)
    assert.is_string(item.insertText)
    assert.equals(vim.lsp.protocol.CompletionItemKind.Snippet, item.kind)
  end)

  it('should contain PHP constructor method', function()
    local item = construct_snippet.create()
    
    assert.is_true(string.find(item.insertText, '__construct') ~= nil, 
      'should contain __construct method')
    assert.is_true(string.find(item.insertText, 'public function') ~= nil,
      'should be a public function')
  end)

  it('should use snippet format for proper indentation', function()
    local item = construct_snippet.create()
    
    -- Should use snippet format for proper indentation handling
    assert.equals(vim.lsp.protocol.InsertTextFormat.Snippet, item.insertTextFormat)
    -- Should contain snippet placeholders
    assert.is_true(string.find(item.insertText, '%$%d') ~= nil,
      'should contain snippet placeholders for cursor positioning')
  end)

  it('should provide parameter placeholder and cursor positioning', function()
    local item = construct_snippet.create()
    
    -- Should have $1 for parameters and $0 for final cursor position
    assert.is_true(string.find(item.insertText, '%$1') ~= nil,
      'should have $1 placeholder for parameters')
    assert.is_true(string.find(item.insertText, '%$0') ~= nil,
      'should have $0 placeholder for final cursor position')
  end)
end)