local devicons = require 'nvim-web-devicons'
-- local lsp_status
local _, lsp_status = pcall(require, 'lsp-status')

local get_mode = vim.api.nvim_get_mode
local get_current_win = vim.api.nvim_get_current_win
local get_window_buf = vim.api.nvim_win_get_buf
local buf_get_name = vim.api.nvim_buf_get_name
local buf_get_option = vim.api.nvim_buf_get_option
local fnamemodify = vim.fn.fnamemodify
local get_window_width = vim.api.nvim_win_get_width
local pathshorten = vim.fn.pathshorten
local FugitiveReal = vim.fn.FugitiveReal

local function highlight(name, opts, default)
  local hi_cmd = { 'hi', name }

  if default then
    table.insert(hi_cmd, 2, 'default')
  end

  for opt, value in pairs(opts or {}) do
    table.insert(hi_cmd, string.format('%s=%s', opt, value))
  end

  vim.cmd(table.concat(hi_cmd, ' '))
end

local hi_default = setmetatable({}, {
  __newindex = function(_, name, opts)
    highlight(name, opts, true)
  end
})

local hi = setmetatable({}, {
  __newindex = function(_, name, opts)
    highlight(name, opts)
  end
})

local hi_link = setmetatable({}, {
  __newindex = function(_, from, to)
    vim.cmd(table.concat({ 'hi', 'default', 'link', from, to }, ' '))
  end
})

local function setup_colors()
  hi_default.StatuslineNormalMode = { guifg = '#373b41', guibg = '#81a2be', gui = 'bold' }
  hi_default.StatuslineInsertMode = { guifg = '#373b41', guibg = '#f0c674', gui = 'bold' }
  hi_default.StatuslineVisualMode = { guifg = '#373b41', guibg = '#b294bb', gui = 'bold' }
  hi_default.StatuslineReplaceMode = { guifg = '#373b41', guibg = '#de935f', gui = 'bold' }
  hi_default.StatuslineCommandMode = { guifg = '#373b41', guibg = '#81a2be', gui = 'bold' }
  hi_default.StatuslineTerminalMode = { guifg = '#373b41', guibg = '#f0c674', gui = 'bold' }
  hi_default.StatuslineMiscMode = { guifg = '#373b41', guibg = '#a3685a', gui = 'bold' }
  hi_default.StatuslineFilenameNotModified = { guifg = '#c5c8c6', guibg = '#282a2e', gui = 'none' }
  hi_default.StatuslineFilenameModified = { guifg = '#cc6666', guibg = '#282a2e', gui = 'none' }
  hi_default.StatuslineVC = { guifg = '#c5c8c6', guibg = '#373b41', gui = 'none' }
  hi_default.StatuslineDiagnosticsError = { guifg = '#373b41', guibg = '#cc6666', gui = 'bold' }
  hi_default.StatuslineDiagnosticsWarning = { guifg = '#373b41', guibg = '#de935f', gui = 'bold' }
  hi_default.StatuslineDiagnosticsInfo = { guifg = '#373b41', guibg = '#81a2be', gui = 'bold' }
  hi_default.StatuslineDiagnosticsHint = { guifg = '#373b41', guibg = '#8abeb7', gui = 'bold' }
  hi_default.StatuslineRadOnly = { guifg = '#cc6666', guibg = '#282a2e', gui = 'bold' }

  hi_link.StatuslineMode = 'StatuslineNormalMode'
  hi_link.StatuslineFilename = 'StatuslineFilenameNotModified'
  hi_link.StatuslineFiletype = 'StatuslineFilenameNotModified'
  hi_link.StatuslineIconNotModified = 'StatuslineFilenameNotModified'
  hi_link.StatuslineIconModified = 'StatuslineFilenameModified'
  hi_link.StatuslineDiagnostics = 'None'
  hi_link.StatuslineLspMessages = 'StatuslineFilenameNotModified'

  -- cmd([[hi StatuslineTS guibg=#3a3a3a gui=none guifg=#878787]])
end

-- List of mode -> :h mode()
-- Use ony the first letter as recommended by the documentation
-- Use byte code because for some modes it's what we got, for instance with visual block
local mode2byte = {
  normal = 110,
  prompt = 114,
  command = 99,
  shell = 33,
  insert = 105,
  terminal = 116,
  visual = 118,
  visual_line = 86,
  visual_block = 22,
  replace = 82,
  select = 115,
  select_line = 83,
  select_block = 94,
}

local mode_text = {
  [mode2byte.normal] = 'N',
  [mode2byte.prompt] = 'P',
  [mode2byte.command] = 'C',
  [mode2byte.shell] = 'SHELL',
  [mode2byte.insert] = 'I',
  [mode2byte.terminal] = 'T',
  [mode2byte.visual] = 'V',
  [mode2byte.visual_line] = 'VL',
  [mode2byte.visual_block] = 'VB',
  [mode2byte.replace] = 'R',
  [mode2byte.select] = 'S',
  [mode2byte.select_line] = 'SL',
  [mode2byte.select_block] = 'SB',
}

local mode_hlgrp = {
  [mode2byte.normal] = 'StatuslineNormalMode',
  [mode2byte.insert] = 'StatuslineInsertMode',
  [mode2byte.visual] = 'StatuslineVisualMode',
  [mode2byte.replace] = 'StatuslineReplaceMode',
  [mode2byte.command] = 'StatuslineCommandMode',
  [mode2byte.terminal] = 'StatuslineTerminalMode',
}
mode_hlgrp[mode2byte.prompt] = mode_hlgrp[mode2byte.command]
mode_hlgrp[mode2byte.shell] = mode_hlgrp[mode2byte.command] -- shell or external cmd is executing
mode_hlgrp[mode2byte.visual_line] = mode_hlgrp[mode2byte.visual]
mode_hlgrp[mode2byte.visual_block] = mode_hlgrp[mode2byte.visual]
mode_hlgrp[mode2byte.select] = mode_hlgrp[mode2byte.replace]
mode_hlgrp[mode2byte.select_line] = mode_hlgrp[mode2byte.replace]
mode_hlgrp[mode2byte.select_block] = mode_hlgrp[mode2byte.replace]

local function mode_name(mode)
  mode = mode or 'n'
  local hlgrp = mode_hlgrp[mode:byte()] or 'StatuslineMiscMode'

  vim.cmd([[hi link StatuslineMode ]] .. hlgrp)

  return string.upper(mode_text[mode:byte()] or string.format('? %s ?', mode))
end

local function spell()
  return vim.o.spell and string.format(' [%s]', vim.o.spelllang) or ''
end

local function paste()
  return vim.o.paste and ' [PASTE]' or ''
end

local function icon(path)
  local name = fnamemodify(path, ':t')
  local extension = fnamemodify(path, ':e')

  return devicons.get_icon(name, extension, { default = true })
end

local function vcs()
  local git_info = vim.b.gitsigns_status_dict
  if not git_info or git_info.head == '' then
    return ''
  end

  -- local branch_sign = ''
  local branch_sign = ''
  -- local added = git_info.added and ('+' .. git_info.added .. ' ') or ''
  -- local modified = git_info.changed and ('~' .. git_info.changed .. ' ') or ''
  -- local removed = git_info.removed and ('-' .. git_info.removed .. ' ') or ''
  -- local pad = ((added ~= '') or (removed ~= '') or (modified ~= '')) and ' ' or ''
  -- local diff_str = string.format('%s%s%s%s', added, removed, modified, pad)

  -- return string.format('%s%s %s ', diff_str, branch_sign, git_info.head)
  return string.format(' %s %s ', branch_sign, git_info.head)
end

local function filename(buf_name, win_id)
  local base_name

  if "" == buf_name then
    return '[No Name]'
  elseif buf_name:match('^fugitive://') then
    base_name = fnamemodify(FugitiveReal(buf_name), [[:~:.]]) .. ' [Git]'
  else
    base_name = fnamemodify(buf_name, [[:~:.]])
  end

  local space = math.min(50, math.floor(0.4 * get_window_width(win_id)))
  if string.len(base_name) <= space then
    return base_name
  else
    return pathshorten(base_name)
  end
end

local function file_modified_symbol(modified)
  if modified then
    vim.cmd([[hi link StatuslineModified StatuslineIconModified]])
    vim.cmd([[hi link StatuslineFilename StatuslineFilenameModified]])

    return ''
    -- return '  ●'
  else
    vim.cmd([[hi link StatuslineModified StatuslineIconNotModified]])
    vim.cmd([[hi link StatuslineFilename StatuslineFilenameNotModified]])

    return ''
  end
end

local function readonly(bufnr)
  return buf_get_option(bufnr, 'readonly') and '  ' or ''
end

local function percent()
  local percentage = (vim.fn.line('.') * 100) / vim.fn.line('$')

  return 50 < vim.fn.winwidth(0) and string.format('%3d%%%% ☰ ', percentage) or ''
end

local function maxline()
  return 100 < vim.fn.winwidth(0) and string.format('%d  ', vim.fn.line('$')) or ''
end

-- TODO implement $/progress on phpactor
-- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#progress
-- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#workDoneProgress
-- TODO create a handler for messages usin notification with https://github.com/rcarriga/nvim-notify ?
local function lsp_messages()
  return lsp_status and lsp_status.status_progress() or ''
end

local function lsp_diagnostics(bufnr)
  if not lsp_status or #vim.lsp.buf_get_clients(bufnr) == 0 then
    return ''
  end

  local errors = lsp_status.status_errors(bufnr)
  local warnings = lsp_status.status_warnings(bufnr)
  local info = lsp_status.status_info(bufnr)
  local hints = lsp_status.status_hints(bufnr)
  local diagnostics = {}

  if errors then
    vim.cmd([[hi link StatuslineDiagnostics StatuslineDiagnosticsError]])
    table.insert(diagnostics, errors)
  elseif warnings then
    vim.cmd([[hi link StatuslineDiagnostics StatuslineDiagnosticsWarning]])
    table.insert(diagnostics, warnings)
  elseif info then
    vim.cmd([[hi link StatuslineDiagnostics StatuslineDiagnosticsInfo]])
    table.insert(diagnostics, info)
  elseif hints then
    vim.cmd([[hi link StatuslineDiagnostics StatuslineDiagnosticsHint]])
    table.insert(diagnostics, hints)
  else
    return ''
  end

  return string.format(' %s ', table.concat(diagnostics, ' '))
end

local active_format =
  '%%#StatuslineMode# %s %%<%%#StatuslineVC#%s%%#StatuslineFiletype# %s %%#StatuslineModified#%s%%#StatuslineFilename# %s%%#StatuslineRadOnly#%s%%#StatuslineLspMessages#%s%%=%%#StatuslineVC#%s%s%%#StatuslineDiagnostics#%s'
local inactive_format = '%%#StatuslineFiletype# %s %%#StatuslineModified#%s%%#StatuslineFilename# %s%%#StatuslineRadOnly#%s'

local statuslines = {}
local function status()
  local win_id = vim.g.statusline_winid
  local bufnr = get_window_buf(win_id)
  local bufname = buf_get_name(bufnr)

  if get_current_win() == win_id or statuslines[win_id] == nil then
    local mode = get_mode().mode
    local line_col_segment = '%#StatuslineMode# %l:%c '
    statuslines[win_id] = string.format(
      active_format,
      mode_name(mode) .. spell() .. paste(),
      vcs(),
      icon(bufname),
      -- TODO merge filename with symbol and readonly components (and icon ?)
      -- TODO try to achieve something like lsp_messages() or filename(bufname, win_id)
      -- to have more places for messages when there is some
      -- the filename is in the tabline anyway
      file_modified_symbol(buf_get_option(bufnr, 'modified')),
      filename(bufname, win_id),
      readonly(bufnr),
      lsp_messages(),
      table.concat({ percent(), maxline() }),
      line_col_segment,
      lsp_diagnostics(bufnr)
    )
  elseif get_current_win() ~= win_id then
    statuslines[win_id] = string.format(
      inactive_format,
      icon(bufname),
      file_modified_symbol(buf_get_option(bufnr, 'modified')),
      filename(bufname, win_id),
      readonly(bufnr)
    )
  end

  return statuslines[win_id]
end

return {
  status = status,
  hi = hi,
  hi_default = hi_default,
  hi_link = hi_link,
  setup_colors = setup_colors,
}
