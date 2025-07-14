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

  it('should provide valid n_mu snippet for public method', function()
    local item = method_snippet.method_public()
    assert.snippet(
      'n_mu',
      [[
      public function ${1:name}($2): ${3:void}
      {
        $0
      }
    ]],
      item
    )
  end)

  it('should provide valid n_mo snippet for protected method', function()
    local item = method_snippet.method_protected()
    assert.snippet(
      'n_mo',
      [[
      protected function ${1:name}($2): ${3:void}
      {
        $0
      }
    ]],
      item
    )
  end)

  it('should provide valid n_mi snippet for private method', function()
    local item = method_snippet.method_private()
    assert.snippet(
      'n_mi',
      [[
      private function ${1:name}($2): ${3:void}
      {
        $0
      }
    ]],
      item
    )
  end)

  it('should provide valid n_mus snippet for public static method', function()
    local item = method_snippet.method_public_static()
    assert.snippet(
      'n_mus',
      [[
      public static function ${1:name}($2): ${3:void}
      {
        $0
      }
    ]],
      item
    )
  end)

  it('should provide valid n_mos snippet for protected static method', function()
    local item = method_snippet.method_protected_static()
    assert.snippet(
      'n_mos',
      [[
      protected static function ${1:name}($2): ${3:void}
      {
        $0
      }
    ]],
      item
    )
  end)

  it('should provide valid n_mis snippet for private static method', function()
    local item = method_snippet.method_private_static()
    assert.snippet(
      'n_mis',
      [[
      private static function ${1:name}($2): ${3:void}
      {
        $0
      }
    ]],
      item
    )
  end)
end)
