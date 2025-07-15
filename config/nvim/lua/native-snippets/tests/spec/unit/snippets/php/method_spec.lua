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
  local snippets = method_snippet.generate_all_snippets()

  -- Helper function to find a specific snippet by label from the generated snippets
  local function find_snippet_by_label(label)
    for _, snippet in ipairs(snippets) do
      if snippet.label == label then
        return snippet
      end
    end
    error("Snippet with label '" .. label .. "' not found")
  end

  describe('choice methods', function()
    it('should provide valid n_method_choice snippet with visibility choices', function()
      assert.snippet(
        [[
        ${1|public,protected,private|} function ${2:name}($3): ${4:void}
        {
          $0
        }
        ]],
        method_snippet.method_choice()
      )
    end)
  end)

  describe('basic methods', function()
    it('should provide valid n_mu snippet for public method', function()
      assert.snippet(
        [[
        public function ${1:name}($2): ${3:void}
        {
          $0
        }
        ]],
        find_snippet_by_label('n_mu')
      )
    end)

    it('should provide valid n_mo snippet for protected method', function()
      assert.snippet(
        [[
        protected function ${1:name}($2): ${3:void}
        {
          $0
        }
        ]],
        find_snippet_by_label('n_mo')
      )
    end)

    it('should provide valid n_mi snippet for private method', function()
      assert.snippet(
        [[
        private function ${1:name}($2): ${3:void}
        {
          $0
        }
        ]],
        find_snippet_by_label('n_mi')
      )
    end)
  end)

  describe('static methods', function()
    it('should provide valid n_mus snippet for public static method', function()
      assert.snippet(
        [[
        public static function ${1:name}($2): ${3:void}
        {
          $0
        }
        ]],
        find_snippet_by_label('n_mus')
      )
    end)

    it('should provide valid n_mos snippet for protected static method', function()
      assert.snippet(
        [[
        protected static function ${1:name}($2): ${3:void}
        {
          $0
        }
        ]],
        find_snippet_by_label('n_mos')
      )
    end)

    it('should provide valid n_mis snippet for private static method', function()
      assert.snippet(
        [[
        private static function ${1:name}($2): ${3:void}
        {
          $0
        }
        ]],
        find_snippet_by_label('n_mis')
      )
    end)
  end)

  describe('abstract methods', function()
    it('should provide valid n_mau snippet for abstract public method', function()
      assert.snippet(
        [[
        abstract public function ${1:name}($2): ${3:void};
        ]],
        find_snippet_by_label('n_mau')
      )
    end)

    it('should provide valid n_mao snippet for abstract protected method', function()
      assert.snippet(
        [[
        abstract protected function ${1:name}($2): ${3:void};
        ]],
        find_snippet_by_label('n_mao')
      )
    end)

    it('should provide valid n_mai snippet for abstract private method', function()
      assert.snippet(
        [[
        abstract private function ${1:name}($2): ${3:void};
        ]],
        find_snippet_by_label('n_mai')
      )
    end)
  end)
end)
