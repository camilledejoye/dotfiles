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

  it('should provide valid n_method snippet', function()
    local item = method_snippet.method()
    assert.snippet(
      'n_method',
      [[
      ${1:public} function ${2:name}($3): ${4:void}
      {
        $0
      }
    ]],
      item
    )
  end)

  it('should provide valid n_method_choice snippet with visibility choices', function()
    local item = method_snippet.method_choice()
    assert.snippet(
      'n_method_choice',
      [[
      ${1|public,protected,private|} function ${2:name}($3): ${4:void}
      {
        $0
      }
    ]],
      item
    )
  end)
end)
