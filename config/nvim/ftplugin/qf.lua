local api, fn = vim.api, vim.fn

local function remove_item(index)
  local cursor_line, cursor_column = unpack(api.nvim_win_get_cursor(0))
  local items = fn.getqflist()
  index = index or cursor_line

  table.remove(items, index)
  fn.setqflist(items, 'r')

  if #items < cursor_line then
    cursor_line = #items -- Update the line of the cursor if we deleted the last item
  end

  api.nvim_win_set_cursor(0, { cursor_line, cursor_column })
end

vim.keymap.set('n', 'dd', remove_item, {
  noremap = true,
  silent = true,
  buffer = true,
})
