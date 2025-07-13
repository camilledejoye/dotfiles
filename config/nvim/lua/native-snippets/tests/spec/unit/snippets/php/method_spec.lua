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

require('native-snippets.tests.assertions').register()

describe('PHP method snippet', function()
  local method_snippet = require('native-snippets.snippets.php.method')

  it('should provide valid n_method completion item', function()
    local item = method_snippet.create()
    assert.snippet('n_method', item)
  end)
  it('should contain PHP method structure with visibility', function()
    local item = method_snippet.create()

    assert.is_true(string.find(item.insertText, 'function') ~= nil, 'should contain function keyword')
    assert.is_true(string.find(item.insertText, 'public') ~= nil, 'should have default public visibility')
    assert.is_true(string.find(item.insertText, '{') ~= nil, 'should have opening brace')
    assert.is_true(string.find(item.insertText, '}') ~= nil, 'should have closing brace')
  end)

  it('should provide placeholders for visibility, method name, parameters, return type and body', function()
    local item = method_snippet.create()

    -- Should have placeholders for visibility, method name, parameters, return type, and body
    assert.is_true(string.find(item.insertText, '%${1:') ~= nil, 'should have ${1:} placeholder for visibility')
    assert.is_true(
      string.find(item.insertText, '%${2:name}') ~= nil,
      'should have ${2:name} placeholder for method name'
    )
    assert.is_true(string.find(item.insertText, '%$3') ~= nil, 'should have $3 placeholder for parameters')
    assert.is_true(
      string.find(item.insertText, '%${4:void}') ~= nil,
      'should have ${4:void} placeholder for return type'
    )
    assert.is_true(string.find(item.insertText, '%$0') ~= nil, 'should have $0 placeholder for final cursor position')
  end)

  it('should include default values for name and return type', function()
    local item = method_snippet.create()

    -- Should contain default values
    assert.is_true(string.find(item.insertText, 'name') ~= nil, 'should contain "name" as default method name')
    assert.is_true(string.find(item.insertText, 'void') ~= nil, 'should contain "void" as default return type')
  end)

  it('should include return type syntax', function()
    local item = method_snippet.create()

    -- Should contain colon for return type syntax
    assert.is_true(string.find(item.insertText, ':') ~= nil, 'should contain colon for return type syntax')
  end)
end)
