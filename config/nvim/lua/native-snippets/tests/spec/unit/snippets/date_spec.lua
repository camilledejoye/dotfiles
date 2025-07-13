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

describe('Global date snippet', function()
  local date_snippet = require('native-snippets.snippets.global.date')

  it('should provide valid n_date snippet', function()
    local item = date_snippet.create()
    local expected_date = os.date('%Y-%m-%d')
    assert.plaintext_snippet('n_date', expected_date, item)
  end)
end)
