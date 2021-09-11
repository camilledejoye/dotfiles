local api = vim.api

local function tbl_index(table, value)
  for index, table_value in ipairs(table) do
    if value == table_value then
      return index
    end
  end

  return nil
end

local M = {}

local visibilities = { 'public', 'protected', 'private' }

local function next_visibility(visibility)
  local index = visibility and tbl_index(visibilities, visibility)

  return index and visibilities[3 == index and 1 or index + 1]
end

local function previous_visibility(visibility)
  local index = visibility and tbl_index(visibilities, visibility)

  return index and visibilities[1 == index and 3 or index - 1]
end

function M.cycle_visibility(forward)
  local line = api.nvim_get_current_line()
  local start = line:match('^%s*%l+') -- First word with preceding spaces
  local visibility = start:match('%l+')
  local new_visibility = forward
    and next_visibility(visibility)
    or previous_visibility(visibility)

  local start_row = vim.fn.line('.') - 1 -- zero-based index
  local start_col = #start - #visibility
  local end_col = #start

  api.nvim_buf_set_text(0, start_row, start_col, start_row, end_col, { new_visibility })
end

return M
