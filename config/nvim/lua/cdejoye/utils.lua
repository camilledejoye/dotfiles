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

function M.hi(name, definition, default)
  local is_link = 'string' == type(definition)

  if not is_link then
    local stringified_opts = {}

    for opt_name, value in pairs(definition) do
      table.insert(stringified_opts, string.format('%s=%s', opt_name, value))
    end

    definition = table.concat(stringified_opts, ' ')
  end

  vim.cmd(string.format(
    'highlight%s %s %s %s',
    default and ' default' or '!',
    is_link and 'link' or '',
    name,
    definition
  ))
end

return M
