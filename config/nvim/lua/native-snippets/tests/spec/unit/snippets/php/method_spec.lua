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
  it('should generate expected PHP method snippet text', function()
    local item = method_snippet.create()

    assert.snippet.text([[
      ${1:public} function ${2:name}($3): ${4:void}
      {
        $0
      }
    ]], item)
  end)
end)
