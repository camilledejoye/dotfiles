local Trouble = require('trouble')

function Trouble:next_fold()
  local view = Trouble:get_view()
  local line = view:get_line()
  for i = line + 1, vim.api.nvim_buf_line_count(view.buf), 1 do
    if view.items[i] and view.items[i].is_file then
      vim.api.nvim_win_set_cursor(view.win, { i, view:get_col() })
      return
    end
  end
end

function Trouble:previous_fold()
  local view = Trouble:get_view()
  local line = view:get_line()
  for i = line - 1, 0, -1 do
    if view.items[i] and view.items[i].is_file then
      vim.api.nvim_win_set_cursor(view.win, { i, view:get_col() })
      return
    end
  end
end

return Trouble
