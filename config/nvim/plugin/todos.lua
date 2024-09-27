local loaded, window = pcall(require, 'lspsaga.window')
local map = require('cdejoye.utils').map

if not loaded then
  return vim.notify(
    'Todos plugin disabled because lspsaga could not be loaded',
    vim.log.levels.WARN
  )
end

local function create_window(bufnr)
  local max_height = math.floor(vim.o.lines * 0.5)
  local max_width = math.floor(vim.o.columns * 0.3)
  local row = math.floor((vim.o.lines - max_height) / 2)
  local col = math.floor((vim.o.columns - max_width) / 2)

  local opts = {
    bufnr = bufnr,
    relative = 'editor',
    style = 'minimal',
    height = max_height,
    width = max_width,
    offset_y = row,
    offset_x = col,
  }

  if 1 == vim.fn.has('nvim-0.9') then
    opts.title = { { 'Todo', 'TitleString' } }
  end

  local _, winid = window
    :new_float(opts, true, false)
    :winhl('Normal', 'FloatBorder')
    :wininfo()

  return winid
end

local function open()
  local fname = vim.fn.getcwd().."/todos.norg"
  local bufnr = vim.uri_to_bufnr(vim.uri_from_fname(fname))

  if not vim.api.nvim_buf_is_loaded(bufnr) then
    vim.fn.bufload(bufnr)
  end

  local winid = create_window(bufnr)
  vim.api.nvim_win_set_buf(winid, bufnr)
  vim.api.nvim_set_option_value('winbar', '', { scope = 'local', win = winid })
  vim.bo[bufnr].modifiable = true;
end

map('<Leader>ll', open, 'n')
