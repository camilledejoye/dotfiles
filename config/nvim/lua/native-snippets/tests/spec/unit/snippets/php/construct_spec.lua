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

describe('PHP constructor snippets', function()
  local construct_snippet = require('native-snippets.snippets.php.construct')

  it('should provide valid n_cu (public constructor) snippet', function()
    local item = construct_snippet.create_public()
    assert.snippet(
      'n_cu',
      [[
      public function __construct($1)
      {
        $0
      }
    ]],
      item
    )
  end)

  it('should provide valid n_co (protected constructor) snippet', function()
    local item = construct_snippet.create_protected()
    assert.snippet(
      'n_co',
      [[
      protected function __construct($1)
      {
        $0
      }
    ]],
      item
    )
  end)

  it('should provide valid n_ci (private constructor) snippet', function()
    local item = construct_snippet.create_private()
    assert.snippet(
      'n_ci',
      [[
      private function __construct($1)
      {
        $0
      }
    ]],
      item
    )
  end)
end)
