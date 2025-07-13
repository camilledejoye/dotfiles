local describe = require('plenary.busted').describe
local it = require('plenary.busted').it
local assert = require('luassert')

describe('nvim-cmp integration', function()
  local cmp
  local source

  it('registers native_snippets source in cmp config', function()
    -- Load cmp configuration
    require('cdejoye.config.cmp')
    cmp = require('cmp')

    local sources = cmp.get_config().sources
    local found_source = false

    for _, src in ipairs(sources or {}) do
      if src.name == 'native_snippets' then
        found_source = true
        break
      end
    end

    assert.is_true(found_source, 'native_snippets source should be registered')
  end)

  it('provides completion items for PHP files', function()
    source = require('native-snippets')

    -- Mock PHP filetype
    _G.vim.bo.filetype = 'php'

    local completed = false
    local items = {}

    source:complete({}, function(result)
      completed = true
      items = result.items or {}
    end)

    -- Wait for async completion
    vim.wait(100, function()
      return completed
    end)

    assert.is_true(completed, 'completion callback should be called')
    assert.is_true(#items > 0, 'should return completion items for PHP')

    local first_item = items[1]
    assert.equals(vim.lsp.protocol.CompletionItemKind.Snippet, first_item.kind)
    assert.is_not_nil(first_item.label)
    assert.is_not_nil(first_item.insertText)
  end)

  it('returns global snippets for non-PHP files', function()
    source = require('native-snippets')

    -- Mock JavaScript filetype
    _G.vim.bo.filetype = 'javascript'

    local completed = false
    local items = {}

    source:complete({}, function(result)
      completed = true
      items = result.items or {}
    end)

    -- Wait for async completion
    vim.wait(100, function()
      return completed
    end)

    assert.is_true(completed, 'completion callback should be called')
    assert.equals(1, #items, 'should return global snippets for non-PHP files')
    assert.equals('n_date', items[1].label, 'should include global date snippet')
  end)

  it('generates dynamic date content', function()
    source = require('native-snippets')

    _G.vim.bo.filetype = 'php'

    local completed = false
    local items = {}

    source:complete({}, function(result)
      completed = true
      items = result.items or {}
    end)

    vim.wait(100, function()
      return completed
    end)

    local date_item = items[1]
    local current_date = os.date('%Y-%m-%d')

    assert.equals(current_date, date_item.insertText, 'snippet should contain current date: ' .. current_date)
  end)
end)
