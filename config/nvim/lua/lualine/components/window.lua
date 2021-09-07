local icons_provider = require('lualine.icons.provider');
local highlight = require('lualine.highlight')
local utils = require('lualine.utils.utils')

local Component = require('lualine.component'):new()
local FileNameWithIcon = require('lualine.components.filename-with-icon')
local Window = Component:new()

local function extract_color(color, type, default_hl_group)
  vim.validate {
    color = { color, 'table' },
    type = { type, 'string' },
    default_hl_group = { default_hl_group, 'string' },
  }

  if not color[type] then
    return utils.extract_highlight_colors(default_hl_group, type)
  end

  if color[type]:match('^#') then
    return color
  end

  return utils.extract_highlight_colors(color[type], type)
end

function Window:new(options, child, winnr)
  local this = self._parent:new(options, child or self)

  this.winnr = winnr or vim.api.nvim_get_current_win()

  if this.component_no then -- If real component and not in case of inheritance
    this.options.symbols = vim.tbl_extend(
      'force',
      { modified = '●', readonly = '' },
      this.options.symbols or {}
    )

    this.options.window = vim.tbl_deep_extend('force', {
      colors = {
        active = { unmodified = 'lualine_a_normal', modified = 'lualine_a_insert' },
        inactive = { unmodified = 'lualine_b_normal', modified = {} },
      }
    }, this.options.window or {})

    -- TODO rework this part once https://github.com/hoob3rt/lualine.nvim/pull/311 will be
    -- merged because there is some changes about colors management
    local section = this.options.self.section
    for focus, statuses in pairs(this.options.window.colors) do
      local default_hl_group = highlight.format_highlight('active' == focus, section)

      for _, status in ipairs({ 'unmodified', 'modified' }) do
        local color = statuses[status]

        if 'modified' == status then
          default_hl_group = this.options.window.colors[focus].unmodified
        end

        if 'table' == type(color) then
          local fg = extract_color(color, 'fg', default_hl_group)
          local bg = extract_color(color, 'bg', default_hl_group)
          local gui = color.gui or utils.extract_highlight_colors(default_hl_group, 'gui')
          local new_hl_group = string.format('tab_%s_%s', focus, status)

          this.options.window.colors[focus][status] = highlight.create_component_highlight_group(
            { fg = fg, bg = bg, gui = gui },
            new_hl_group
          )
        elseif 'string' ~= type(color) then
          error('A color must either be a string or a table')
        end
      end
    end
  end

  return this
end

function Window:get_highlight()
  local focus = self:is_active() and 'active' or 'inactive'
  local status = self:is_modified() and 'modified' or 'unmodified'

  return self.options.window.colors[focus][status]
end

function Window:is_active()
  return vim.api.nvim_get_current_win() == self.winnr
end

function Window:is_modified()
  return vim.api.nvim_buf_get_option(self:get_bufnr(), 'modified')
end

function Window:get_bufnr()
  return vim.api.nvim_win_get_buf(self.winnr)
end

function Window:get_bufname()
  return vim.api.nvim_buf_get_name(
    self:get_bufnr()
  )
end

function Window:update_status()
  self.options.icon = icons_provider:for_buffer(self:get_bufnr())

  local parts = { FileNameWithIcon.get_filename(self:get_bufname(), ':t') }

  if self:is_modified() then
    table.insert(parts, self.options.symbols.modified)
  end

  self.options.color_highlight_link = self:get_highlight()

  return table.concat(parts, ' ')
end

return Window
