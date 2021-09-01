local M = {}

local function convert_opts(opts)
  local converted_opts = {}
  for k, v in pairs(opts) do
    if 'string' == type(k) and 'boolean' == type(v) then
      converted_opts[k] = v
    elseif 'number' == type(k) and 'string' == type(v) then
      converted_opts[v] = true
    end
  end

  return converted_opts
end

function M.map(lhs, rhs, modes, opts, bufnr)
  modes = modes or 'n'
  opts = convert_opts(opts or {})
  opts = vim.tbl_extend('keep', opts, {
    noremap = true,
    silent = true,
  })

  modes:gsub('.', function(mode)
    if not bufnr then
      vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
    else
      vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end
  end)
end

function M.bmap(bufnr, lsh, rhs, mode, opts)
  M.map(lsh, rhs, mode, opts, bufnr)
end

return M
