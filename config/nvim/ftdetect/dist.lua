-- List of extensions which does not match their filetype
local ext_to_filetype_map = { yml = 'yaml' }

---@param file string
---@return string
local function detect_filetype(file)
  local ext_without_dist = file:match('.*%.(%w+)%.%w+$')

  return ext_to_filetype_map[ext_without_dist] or ext_without_dist
end

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.dist',
  callback = function(args)
    vim.bo.filetype = detect_filetype(args.file)
  end,
})
