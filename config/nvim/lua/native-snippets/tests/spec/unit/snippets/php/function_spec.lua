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

describe('PHP function snippet', function()
  local function_snippet = require('native-snippets.snippets.php.function')

  it('should provide valid n_function snippet', function()
    local item = function_snippet.func()
    assert.snippet(
      'n_function',
      [[
      function ${1:name}($2): ${3:void}
      {
        $0
      }
    ]],
      item
    )
  end)
end)
