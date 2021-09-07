local highlight = require('lualine.highlight')

local Window = require('lualine.components.window')
local Windows = require('lualine.component'):new()

function Windows:get_win_list()
  print('Windows.get_win_list should not be reached, you probably have forgot to override it!')

  return {}
end

function Windows:create_window(winnr)
  local window_options = vim.tbl_extend('keep', self.options, {})

  return Window:new(window_options, Window, winnr)
end

function Windows:update_status()
  local drawn_windows = {}

  for _, winnr in ipairs(self:get_win_list()) do
    local bufnr = vim.api.nvim_win_get_buf(winnr)
    local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    local is_filetype_disabled = vim.tbl_contains(self.options.disabled_filetypes, filetype)
    -- Ignoring `nofile` buffer is an attempt to hide buffers that we are not interested
    -- in. For examples Telescope use a lot of buffers/windows that we don't want to see
    -- in our tabline.
    local is_nofile = 'nofile' == vim.api.nvim_buf_get_option(bufnr, 'buftype')
    local should_be_hidden = is_filetype_disabled or is_nofile

    if not should_be_hidden then
      local window = self:create_window(winnr)
      local section_highlight = highlight.format_highlight(false, self.options.self.section)

      table.insert(drawn_windows, window:draw(section_highlight))
    end
  end

  return table.concat(drawn_windows)
end

return Windows
