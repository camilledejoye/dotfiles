--- Text diff utilities for test assertions
--- Provides git-style colored diffs with character-level highlighting
local M = {}

-- =============================================================================
-- ANSI Color Codes
-- =============================================================================

local COLORS = {
  reset = '\027[0m',

  -- Red background with white text for expected lines (what we EXPECT)
  red_bg = '\027[41m',
  -- Green background with white text for actual lines (what we RECEIVED)
  green_bg = '\027[42m',

  -- Brighter highlighting for character differences
  red_bg_bright = '\027[101m',
  green_bg_bright = '\027[102m',
}

-- =============================================================================
-- Utility Functions
-- =============================================================================

--- Check if terminal supports colors
--- @return boolean
local function supports_color()
  local term = os.getenv('TERM')
  return term and term ~= 'dumb'
end

--- Split text into lines
--- @param text string
--- @return table lines
local function split_lines(text)
  local lines = {}
  for line in (text .. '\n'):gmatch('(.-)\n') do
    table.insert(lines, line)
  end
  return lines
end

-- =============================================================================
-- Character-Level Diff Within Lines
-- =============================================================================

--- Find character differences between two strings
--- @param old_line string
--- @param new_line string
--- @return string old_highlighted, string new_highlighted
local function highlight_char_differences(old_line, new_line)
  if not supports_color() then
    return old_line, new_line
  end

  local old_len = #old_line
  local new_len = #new_line
  local min_len = math.min(old_len, new_len)

  -- Find first difference from the left
  local diff_start = min_len + 1
  for i = 1, min_len do
    if old_line:sub(i, i) ~= new_line:sub(i, i) then
      diff_start = i
      break
    end
  end

  -- Find first difference from the right, stopping at diff_start
  local old_end = old_len
  local new_end = new_len

  while old_end >= diff_start and new_end >= diff_start do
    if old_line:sub(old_end, old_end) ~= new_line:sub(new_end, new_end) then
      break
    end
    old_end = old_end - 1
    new_end = new_end - 1
  end

  -- Build highlighted strings
  local old_result = old_line
  local new_result = new_line

  if diff_start <= math.max(old_len, new_len) then
    -- For old line
    if diff_start <= old_len then
      local prefix = old_line:sub(1, diff_start - 1)
      local diff_part = old_line:sub(diff_start, old_end)
      local suffix = old_line:sub(old_end + 1)
      old_result = prefix .. COLORS.red_bg_bright .. diff_part .. COLORS.reset .. COLORS.red_bg .. suffix
    end

    -- For new line
    if diff_start <= new_len then
      local prefix = new_line:sub(1, diff_start - 1)
      local diff_part = new_line:sub(diff_start, new_end)
      local suffix = new_line:sub(new_end + 1)
      new_result = prefix .. COLORS.green_bg_bright .. diff_part .. COLORS.reset .. COLORS.green_bg .. suffix
    end
  end

  return old_result, new_result
end

-- =============================================================================
-- Main Diff Function
-- =============================================================================

--- Create a git-style colored diff between two texts
--- @param expected string Expected text
--- @param actual string Actual text
--- @return string Colored diff output
function M.create_diff(expected, actual)
  if not supports_color() then
    return string.format('Expected:\n%s\n\nActual:\n%s', expected, actual)
  end

  local expected_lines = split_lines(expected)
  local actual_lines = split_lines(actual)

  local result = {}

  -- Simple line-by-line diff (can be enhanced with proper diff algorithm later)
  local max_lines = math.max(#expected_lines, #actual_lines)

  for i = 1, max_lines do
    local expected_line = expected_lines[i] or ''
    local actual_line = actual_lines[i] or ''

    if expected_line == actual_line then
      -- Lines are identical
      table.insert(result, '  ' .. expected_line)
    else
      -- Lines differ - show both with character highlighting
      if expected_line ~= '' then
        local highlighted_expected = expected_line
        if actual_line ~= '' then
          highlighted_expected = highlight_char_differences(expected_line, actual_line)
        end
        table.insert(result, COLORS.red_bg .. '- ' .. highlighted_expected .. COLORS.reset)
      end

      if actual_line ~= '' then
        local highlighted_actual = actual_line
        if expected_line ~= '' then
          highlighted_actual = select(2, highlight_char_differences(expected_line, actual_line))
        end
        table.insert(result, COLORS.green_bg .. '+ ' .. highlighted_actual .. COLORS.reset)
      end
    end
  end

  return '\n' .. table.concat(result, '\n')
end

return M
