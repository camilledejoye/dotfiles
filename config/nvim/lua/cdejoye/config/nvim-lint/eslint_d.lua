local linters = require('lint').linters
local eslint_d = linters.eslint_d

local function config_file()
  return vim.fn.findfile('eslint.config.js', vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h') .. ';')
end

table.insert(eslint_d.args, '--config')
table.insert(eslint_d.args, config_file)

return eslint_d
