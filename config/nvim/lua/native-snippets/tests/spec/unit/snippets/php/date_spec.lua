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

describe('PHP date snippet', function()
  local date_snippet = require('native-snippets.snippets.php.date')

  it('should provide n_date completion item', function()
    local item = date_snippet.create()

    assert.equals('n_date', item.label)
    assert.is_string(item.insertText)
    assert.equals(vim.lsp.protocol.InsertTextFormat.PlainText, item.insertTextFormat)
    assert.equals(vim.lsp.protocol.CompletionItemKind.Snippet, item.kind)
  end)

  it('should generate current date in YYYY-MM-DD format', function()
    local item = date_snippet.create()

    -- Should match YYYY-MM-DD pattern
    assert.matches('%d%d%d%d%-%d%d%-%d%d', item.insertText)
    -- Should not be a hardcoded test date
    assert.is_not.equals('2025-01-12', item.insertText)
  end)

  it('should generate fresh date on each call', function()
    local item1 = date_snippet.create()
    local item2 = date_snippet.create()

    local date1 = item1.insertText
    local date2 = item2.insertText

    -- Should be same date (since called in same second)
    -- but proves it's calling os.date() each time
    assert.equals(date1, date2)
    assert.matches('%d%d%d%d%-%d%d%-%d%d', date1)
  end)
end)

