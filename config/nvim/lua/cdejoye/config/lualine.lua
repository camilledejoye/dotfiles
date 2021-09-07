vim.o.showmode = false
vim.o.showtabline = 2

local condition = { width = {
  gt = function(ceiling) return
		function() return ceiling < vim.api.nvim_win_get_width(0) end
	end,
} }

local truncate = {
  function() return '%<' end,
  padding = 0,
}

local function percent()
  local percentage = (vim.fn.line('.') * 100) / vim.fn.line('$')

  return string.format('%3d%%%% ☰', percentage)
end

local function maxline()
  return vim.fn.line('$') .. ' '
end

local function spell()
  return vim.wo.spell and string.format('[%s]', vim.bo.spelllang) or ''
end

local function paste()
  return vim.o.paste and '[P]' or ''
end

-- TODO implement $/progress on phpactor
-- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#progress
-- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#workDoneProgress
-- TODO create a handler for messages usin notification with https://github.com/rcarriga/nvim-notify ?
local function lsp_messages()
  local loaded, lsp_status = pcall(require, 'lsp-status')

  return loaded and lsp_status.status_progress() or ''
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'base16',
    component_separators = {},
    section_separators = {},
    disabled_filetypes = { 'TelescopePrompt', 'TelescopeResults' },
  },
  sections = {
    lualine_a = {
      'short-mode',
      { spell, left_padding = 0, condition = condition.width.gt(100) },
      { paste, left_padding = 0, condition = condition.width.gt(50) },
    },
    lualine_b = { truncate, 'branch' },
    lualine_c = { 'filename-with-icon' },
    lualine_x = { lsp_messages },
    lualine_y = {
      { percent, condition = condition.width.gt(50) },
      { maxline, condition = condition.width.gt(100) },
    },
    lualine_z = { 'location', 'lsp-diagnostics' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename-with-icon' },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {
    lualine_a = { 'tab-windows', truncate },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'tab-list' },
  },
  extensions = { 'fugitive', 'quickfix' },
}

vim.cmd([[
hi default link lualine_tab_active lualine_a_normal
hi default link lualine_tab_inactive lualine_b_normal
]])
