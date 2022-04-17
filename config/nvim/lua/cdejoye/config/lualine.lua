local utils = require('lualine.utils.utils')
local highlight = require('lualine.highlight')

vim.o.showmode = false
vim.o.showtabline = 2

local condition = { width = {
  gt = function(ceiling)
    return function()
      return ceiling < vim.api.nvim_win_get_width(0)
    end
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

local fileicon = { 'filetype', icon_only = true, padding = { left = 1, right = 0 } }
local filename = {
  'filename',
  symbols = { modified = ' ●', readonly = ' ' },
  path = 1, -- relative path
  shorting_target = 0, -- do not shorten filenames
}

local section_redirects = {
  lualine_x = 'lualine_c',
  lualine_y = 'lualine_b',
  lualine_z = 'lualine_a',
}
local function get_hl(section_letter, suffix)
  local section = 'lualine_' .. section_letter

  if section_redirects[section] then
    section = highlight.highlight_exists(section .. '_' .. suffix) and section or section_redirects[section]
  end

  return section .. '_' .. suffix
end

local diagnostics = {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  diagnostics_color = {
    error = function(context)
      return {
        fg = utils.extract_highlight_colors(get_hl(context.section, 'normal'), 'fg'),
        bg = utils.extract_color_from_hllist(
          'fg',
          { 'DiagnosticError', 'LspDiagnosticsDefaultError', 'DiffDelete' },
          '#cc6666'
        ),
      }
    end,
    warn = function(context)
      return {
        fg = utils.extract_highlight_colors(get_hl(context.section, 'normal'), 'fg'),
        bg = utils.extract_color_from_hllist(
          'fg',
          { 'DiagnosticWarn', 'LspDiagnosticsDefaultWarning', 'DiffText' },
          '#de935f'
        ),
      }
    end,
    info = function(context)
      return {
        fg = utils.extract_highlight_colors(get_hl(context.section, 'normal'), 'fg'),
        bg = utils.extract_color_from_hllist(
          'fg',
          { 'DiagnosticInfo', 'LspDiagnosticsDefaultInformation', 'Normal' },
          '#e0e0e0'
        ),
      }
    end,
    hint = function(context)
      return {
        fg = utils.extract_highlight_colors(get_hl(context.section, 'normal'), 'fg'),
        bg = utils.extract_color_from_hllist(
          'fg',
          { 'DiagnosticHint', 'LspDiagnosticsDefaultHint', 'DiffChange' },
          '#81a2be'
        ),
      }
    end,
  },
}

-- TODO implement $/progress on phpactor
-- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#progress
-- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#workDoneProgress
-- TODO create a handler for messages usin notification with https://github.com/rcarriga/nvim-notify ?
local function lsp_messages()
  local loaded, lsp_status = pcall(require, 'lsp-status')

  return loaded and lsp_status.status_progress() or ''
end

require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'auto',
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    disabled_filetypes = { 'TelescopePrompt', 'TelescopeResults' },
    mode = 3,
  },
  sections = {
    lualine_a = {
      'short-mode',
      { spell, left_padding = 0, condition = condition.width.gt(100) },
      { paste, left_padding = 0, condition = condition.width.gt(50) },
    },
    lualine_b = { truncate, 'branch' },
    lualine_c = { fileicon, filename },
    lualine_x = { lsp_messages },
    lualine_y = {
      { percent, condition = condition.width.gt(50) },
      { maxline, condition = condition.width.gt(100) },
    },
    lualine_z = { 'location', diagnostics },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { fileicon, filename },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {
    lualine_a = { 'windows', truncate },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'tabs' },
  },
  extensions = { 'fugitive', 'quickfix' },
})
