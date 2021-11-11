local TabWindows = require('lualine.components.buffers-improved'):extend()

-- Override to only return buffer's numbers shown in the windows of the current tab
function TabWindows:bufnrs()
  local tabnr = vim.api.nvim_get_current_tabpage()
  local buffers = {}

  for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(tabnr)) do
    local bufnr = vim.api.nvim_win_get_buf(winnr)
    local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    local is_filetype_disabled = vim.tbl_contains(self.options.disabled_filetypes, filetype)
    -- Ignoring `nofile` buffer is an attempt to hide buffers that we are not interested
    -- in. For examples Telescope use a lot of buffers/Buffers that we don't want to see
    -- in our tabline.
    local is_nofile = 'nofile' == vim.api.nvim_buf_get_option(bufnr, 'buftype')
    local should_be_hidden = is_filetype_disabled or is_nofile

    if not should_be_hidden then
      buffers[#buffers + 1] = bufnr
    end
  end

  return buffers
end

return TabWindows
