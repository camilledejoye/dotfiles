---@diagnostic disable: undefined-global
local assert = require('luassert')
local describe = require('plenary.busted').describe
local it = require('plenary.busted').it
local before_each = require('plenary.busted').before_each
local after_each = require('plenary.busted').after_each
local stub = require('luassert.stub')

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

describe('Global date snippet', function()
  local date_snippet = require('native-snippets.snippets.global.date')
  local date_stub

  before_each(function()
    date_stub = stub(os, 'date')
    date_stub.on_call_with('%Y-%m-%d').returns('2024-03-15')
    date_stub.on_call_with('%Y-%m-%d %H:%M:%S').returns('2024-03-15 14:30:45')
  end)

  after_each(function()
    if date_stub then
      date_stub:revert()
    end
  end)

  it('should provide valid n_date snippet', function()
    local item = date_snippet.create_date()
    assert.plaintext_snippet('n_date', '2024-03-15', item)
  end)

  it('should provide valid n_datetime snippet', function()
    local item = date_snippet.create_datetime()
    assert.plaintext_snippet('n_datetime', '2024-03-15 14:30:45', item)
  end)
end)
