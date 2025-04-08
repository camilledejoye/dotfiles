local name = 'php-cs-fixer'

---@enum HunkType
local HunkType = {
  Deletion = '-',
  Addition = '+',
  Unchanged = ' ',
}

-- Information for each line in a hunk
-- While they are optional, there will always be either `original_lnum` or `new_lnum`.
-- For deletion lines, only the `original_lnum` will be present.
-- For addition lines, only the `new_lnum` will be present.
-- For unchanged lines, both will be present.
---@class HunkLine
---@field indicator HunkType
---@field original_lnum ?integer Position of the line in the original version
---@field new_lnum ?integer Position of the line in the new version
---@field text string

---@class Hunk
---@field start_lnum integer
---@field end_lnum integer
---@field lines HunkLine[]

--- Returns an iterator for the oneline diff present in the JSON format of php-cs-fixer
---@param text string
local function lines(text)
  assert('string' == type(text))

  return text:gmatch('[^\r\n]+')
end

-- Generate a representation for each hunks present in the diff returned by php-cs-fixer
-- Those hunks can then be processed to define where to show the diagnostics
---@param diff_string string
---@return Hunk[]
local function get_hunks(diff_string)
  ---@type Hunk[]
  local hunks = {}

  ---@type Hunk|nil
  local current_hunk = nil
  local original_line_index = 0
  local new_line_index = 0
  for line in lines(diff_string) do
    local header_line = 1 == line:find('@@', 1, true)
    if header_line then
      if current_hunk then
        table.insert(hunks, current_hunk)
      end

      local start_lnum, hunk_size = line:match('^@@ %-(%d+),(%d+).* @@$')
      current_hunk = {
        start_lnum = start_lnum,
        end_lnum = start_lnum + hunk_size,
        lines = {},
      }
      original_line_index, new_line_index = 0, 0
    end

    if not header_line and current_hunk then
      local indicator = line:sub(1, 1)
      local hunk_line = {
        indicator = indicator,
        original_lnum = HunkType.Addition ~= indicator and current_hunk.start_lnum + original_line_index or nil,
        new_lnum = HunkType.Deletion ~= indicator and current_hunk.start_lnum + new_line_index or nil,
        text = line:sub(2),
      }
      table.insert(current_hunk.lines, hunk_line)
      if HunkType.Deletion == hunk_line.indicator then
        original_line_index = original_line_index + 1
      elseif HunkType.Addition == hunk_line.indicator then
        new_line_index = new_line_index + 1
      else
        original_line_index = original_line_index + 1
        new_line_index = new_line_index + 1
      end
    end
  end
  table.insert(hunks, current_hunk)

  return hunks
end

---@class ChangedLines
---@field lnum integer 1-indexed
---@field end_lnum integer 1-indexed

-- Parse a diff in order to return a list of changed lines in the buffer
---@param diff_string string
---@return ChangedLines[]
local function parse_diff(diff_string)
  local hunks = get_hunks(diff_string)
  local processed_hunks = {}

  local last_hunk = nil
  for _, hunk in pairs(hunks) do
    for _, line in pairs(hunk.lines) do
      if HunkType.Deletion == line.indicator then
        local hunk_lnum = line.original_lnum

        if nil ~= last_hunk and hunk_lnum == (last_hunk.end_lnum + 1) then
          last_hunk.end_lnum = hunk_lnum
        else
          last_hunk = { lnum = hunk_lnum, end_lnum = hunk_lnum }
        end
      elseif nil ~= last_hunk then
        table.insert(processed_hunks, last_hunk)
        last_hunk = nil
      end
    end
    table.insert(processed_hunks, last_hunk)
  end

  return processed_hunks
end

local M = {
  cmd = 'php-cs-fixer',
  args = {
    'fix',
    '--format=json',
    '-v', -- to get the list of errors under `appliedFixers`
    '--diff',
    '--dry-run',
    '--using-cache=no',
    '--show-progress=none',
    '--no-interaction',
    '-', -- to process from stdin
  },
  stdin = true,
  ignore_exitcode = true,
  stream = 'stdout', -- to only get the JSON and none of the human readable output
}

function M.parser(output, bufnr)
  local diagnostics = {}

  if output == nil or vim.trim(output) == '' then
    return diagnostics
  end

  -- Only one file is returned when processing stdin
  local _, file = next(vim.json.decode(output).files)
  if not file then -- no errors
    return diagnostics
  end

  local message = table.concat(file.appliedFixers, ', ');

  for _, hunk in pairs(parse_diff(file.diff)) do
    table.insert(diagnostics, {
      bufnr = bufnr,
      lnum = hunk.lnum - 1, -- diagnostics uses 0-indexed line numbers
      end_lnum = hunk.end_lnum, -- "underline til next line", will underline the full lines even without `col` and `end_col`
      col = 0,
      severity = vim.diagnostic.severity.ERROR,
      message = message,
      source = name,
    })
  end

  return diagnostics
end

return M
