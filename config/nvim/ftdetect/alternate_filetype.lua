-- List of extensions which does not match their filetype
local ext_to_filetype_map = { yml = 'yaml' }

function _DefineAlternateFiletype()
  local filename = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local ext_without_dist = filename:match('.*%.(%w+)%.%w+$')
  local filetype = ext_to_filetype_map[ext_without_dist] or ext_without_dist

  vim.cmd('setfiletype ' .. filetype)
end

vim.cmd([[autocmd BufEnter *.dist,*.local lua _DefineAlternateFiletype()]])
