local icons = require('cdejoye.icons')

local condition = {
  width = {
    gt = function(ceiling)
      return function()
        return ceiling < vim.api.nvim_win_get_width(0)
      end
    end,
  },
}

local truncate = {
  function()
    return '%<'
  end,
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
  symbols = { modified = ' ●', readonly = ' ' },
  path = 1, -- relative path
  shorting_target = 0, -- do not shorten filenames
}

local diagnostics = {
  'diagnostics',
  symbols = {
    error = icons.diagnostics.error .. ' ',
    warn = icons.diagnostics.warn .. ' ',
    info = icons.diagnostics.info .. ' ',
    hint = icons.diagnostics.hint .. ' ',
  },
}

local branch = { 'branch', icon = icons.git.branch }

--- @module lazy
--- @type LazySpec
return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  init = function()
    vim.o.showmode = false
    vim.o.showtabline = 2
  end,
  opts = {
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
      lualine_b = { truncate, branch },
      lualine_c = { fileicon, filename },
      lualine_x = { diagnostics },
      lualine_y = {
        { percent, condition = condition.width.gt(50) },
        { maxline, condition = condition.width.gt(100) },
      },
      lualine_z = { 'location' },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { fileicon, filename },
      lualine_x = { diagnostics },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {
      lualine_a = {
        {
          'windows',
          windows_color = {
            active = {}, -- Use insert mode highlight group for the current buffer
            inactive = 'lualine_a_inactive',
          },
        },
        truncate,
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { 'tabs' },
    },
    extensions = { 'fugitive', 'quickfix' },
  },
}
