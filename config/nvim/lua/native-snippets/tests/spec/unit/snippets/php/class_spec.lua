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

describe('PHP class snippet', function()
  local class_snippet = require('native-snippets.snippets.php.class')

  it('should provide valid n_class snippet', function()
    local item = class_snippet.class()
    assert.snippet(
      'n_class',
      [[
      class $1
      {
        $0
      }
    ]],
      item
    )
  end)
end)
