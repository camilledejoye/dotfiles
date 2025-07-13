--- Custom assertions for native snippets testing
local M = {}

-- =============================================================================
-- Individual Validation Functions
-- =============================================================================

--- Validates that the snippet label matches expected value
--- @param state table luassert state object
--- @param expected_label string The expected label value
--- @param item table The completion item to validate
--- @return boolean success
local function assert_label_equals(state, expected_label, item)
  if item.label ~= expected_label then
    state.failure_message = string.format(
      "Expected snippet label '%s' but got '%s'",
      expected_label,
      tostring(item.label)
    )
    return false
  end
  return true
end

--- Validates that insertText is a string
--- @param state table luassert state object
--- @param item table The completion item to validate
--- @return boolean success
local function assert_insert_text_is_string(state, item)
  if type(item.insertText) ~= 'string' then
    state.failure_message = string.format(
      'Expected insertText to be a string but got %s',
      type(item.insertText)
    )
    return false
  end
  return true
end

--- Validates that completion item kind is Snippet
--- @param state table luassert state object
--- @param item table The completion item to validate
--- @return boolean success
local function assert_completion_item_kind_snippet(state, item)
  if item.kind ~= vim.lsp.protocol.CompletionItemKind.Snippet then
    state.failure_message = string.format(
      'Expected CompletionItemKind.Snippet (%d) but got %s',
      vim.lsp.protocol.CompletionItemKind.Snippet,
      tostring(item.kind)
    )
    return false
  end
  return true
end

--- Validates that insertTextFormat is Snippet
--- @param state table luassert state object
--- @param item table The completion item to validate
--- @return boolean success
local function assert_insert_text_format_snippet(state, item)
  if item.insertTextFormat ~= vim.lsp.protocol.InsertTextFormat.Snippet then
    state.failure_message = string.format(
      'Expected InsertTextFormat.Snippet (%d) but got %s',
      vim.lsp.protocol.InsertTextFormat.Snippet,
      tostring(item.insertTextFormat)
    )
    return false
  end
  return true
end

-- =============================================================================
-- Text Processing Helpers
-- =============================================================================

--- Normalizes multi-line test strings for snippet comparison
--- Removes common indentation and converts spaces to tabs
--- @param text string Raw multi-line string from test
--- @return string Normalized text ready for comparison
local function normalize_snippet_text(text)
  -- Remove leading/trailing whitespace from the entire text
  text = text:gsub('^%s*\n', ''):gsub('\n%s*$', '')

  -- Split into lines
  local lines = {}
  for line in (text .. '\n'):gmatch('(.-)\n') do
    table.insert(lines, line)
  end

  -- Find the minimum indentation (ignoring empty lines)
  local min_indent = math.huge
  for _, line in ipairs(lines) do
    if line:match('%S') then -- line has non-whitespace content
      local indent = line:match('^%s*'):len()
      min_indent = math.min(min_indent, indent)
    end
  end

  -- Remove the common indentation and convert spaces to tabs
  if min_indent < math.huge then
    local processed_lines = {}
    for _, line in ipairs(lines) do
      if line:match('%S') then -- line has content
        local dedented = line:sub(min_indent + 1)
        -- Convert leading spaces (2 spaces = 1 tab) to tabs
        local converted = dedented:gsub('^( +)', function(spaces)
          return string.rep('\t', math.floor(spaces:len() / 2))
        end)
        table.insert(processed_lines, converted)
      else
        table.insert(processed_lines, '') -- preserve empty lines
      end
    end
    return table.concat(processed_lines, '\n')
  end

  return text
end

-- =============================================================================
-- Main Assertion Functions
-- =============================================================================

--- Combined snippet assertion (structure + content validation)
--- Validates both LSP completion item structure and snippet text content
--- @param state table luassert state object
--- @param arguments table Assertion arguments [expected_label, expected_text, item]
--- @return boolean success
local function assert_snippet_complete(state, arguments)
  local expected_label = arguments[1]
  local expected_text = normalize_snippet_text(arguments[2])
  local item = arguments[3]

  -- First validate the structure
  if not (assert_label_equals(state, expected_label, item)
    and assert_insert_text_is_string(state, item)
    and assert_completion_item_kind_snippet(state, item)
    and assert_insert_text_format_snippet(state, item)) then
    return false
  end

  -- Then validate the content
  if item.insertText ~= expected_text then
    local diff = require('native-snippets.tests.diff')
    state.failure_message = diff.create_diff(expected_text, tostring(item.insertText))
    return false
  end

  return true
end

--- Legacy snippet completion item assertion (structure only)
--- Validates LSP completion item structure for snippets
--- @param state table luassert state object
--- @param arguments table Assertion arguments [expected_label, item]
--- @return boolean success
local function assert_snippet_completion_item(state, arguments)
  local expected_label = arguments[1]
  local item = arguments[2]

  return assert_label_equals(state, expected_label, item)
    and assert_insert_text_is_string(state, item)
    and assert_completion_item_kind_snippet(state, item)
    and assert_insert_text_format_snippet(state, item)
end


--- Snippet text content assertion
--- Validates the actual insertText content with normalization
--- @param state table luassert state object
--- @param arguments table Assertion arguments [expected_text, item]
--- @return boolean success
local function assert_snippet_text_content(state, arguments)
  local diff = require('native-snippets.tests.diff')
  
  local expected_text = normalize_snippet_text(arguments[1])
  local item = arguments[2]

  if item.insertText ~= expected_text then
    state.failure_message = diff.create_diff(expected_text, tostring(item.insertText))
    return false
  end

  return true
end

-- =============================================================================
-- Registration
-- =============================================================================

--- Register all snippet assertions with luassert
function M.register()
  local assert = require('luassert')

  -- Register the new combined assertion as the main 'snippet' assertion
  assert:register('assertion', 'snippet', assert_snippet_complete, { 'assertion', 'snippet' })
  
  -- Register legacy assertions for backward compatibility
  assert:register('assertion', 'snippet_structure', assert_snippet_completion_item, { 'assertion', 'snippet_structure' })
  assert:register('assertion', 'snippet_text', assert_snippet_text_content, { 'assertion', 'snippet_text' })

  -- Setup dot notation for legacy assert.snippet.text() and structure-only
  local original_snippet = assert.snippet
  assert.snippet = setmetatable({
    text = function(expected_text, item)
      return assert.snippet_text(expected_text, item)
    end,
    structure = function(expected_label, item)
      return assert.snippet_structure(expected_label, item)
    end
  }, {
    __call = function(_, ...)
      return original_snippet(...)
    end
  })
end

return M