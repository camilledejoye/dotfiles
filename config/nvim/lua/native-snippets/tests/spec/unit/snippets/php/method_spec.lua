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

describe('PHP method snippet', function()
  local method_snippet = require('native-snippets.snippets.php.method')

  it('should provide n_method completion item', function()
    local item = method_snippet.create()

    assert.equals('n_method', item.label)
    assert.is_string(item.insertText)
    assert.equals(vim.lsp.protocol.CompletionItemKind.Snippet, item.kind)
  end)

  it('should contain PHP method structure with visibility', function()
    local item = method_snippet.create()

    assert.is_true(string.find(item.insertText, 'function') ~= nil, 'should contain function keyword')
    assert.is_true(string.find(item.insertText, 'public') ~= nil, 'should have default public visibility')
    assert.is_true(string.find(item.insertText, '{') ~= nil, 'should have opening brace')
    assert.is_true(string.find(item.insertText, '}') ~= nil, 'should have closing brace')
  end)

  it('should use snippet format for proper indentation', function()
    local item = method_snippet.create()

    -- Should use snippet format for proper indentation handling
    assert.equals(vim.lsp.protocol.InsertTextFormat.Snippet, item.insertTextFormat)
    -- Should contain snippet placeholders
    assert.is_true(
      string.find(item.insertText, '%$%d') ~= nil,
      'should contain snippet placeholders for cursor positioning'
    )
  end)

  it('should provide placeholders for visibility, method name, parameters and body', function()
    local item = method_snippet.create()

    -- Should have placeholders for visibility, method name, parameters, and body
    assert.is_true(string.find(item.insertText, '%$%d') ~= nil, 'should have $1 placeholder for visibility')
    assert.is_true(string.find(item.insertText, '%$2') ~= nil, 'should have $2 placeholder for method name')
    assert.is_true(string.find(item.insertText, '%$3') ~= nil, 'should have $3 placeholder for parameters')
    assert.is_true(string.find(item.insertText, '%$0') ~= nil, 'should have $0 placeholder for final cursor position')
  end)
end)
