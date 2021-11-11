local highlight = require('lualine.highlight')
local icons_provider = require('lualine.icons.provider');
local utils = require('lualine.utils.utils')

local FileNameWithIcon = require('lualine.component'):extend()

local components = {}

local function get_statusline_win()
  -- If the variable `g:actual_curwin` is defined it means that the current window was set
  -- to the window  the status line belongs to, see: `:h stl-%{`
  -- Otherwise the variable `g:statusline_winid` is set to the window's ID the status line
  -- belongs to, see: `:h g:statusline_winid`
  return vim.g.actual_curwin and vim.api.nvim_get_current_win() or vim.g.statusline_winid
end

local function get_statusline_buf()
  return vim.api.nvim_win_get_buf(get_statusline_win())
end

local function buf_get_option(name)
  return vim.api.nvim_buf_get_option(get_statusline_buf(), name)
end

local function win_get_width()
  return vim.api.nvim_win_get_width(get_statusline_win())
end

local function buf_get_name()
  return vim.api.nvim_buf_get_name(get_statusline_buf())
end

local function add_fg_highlight(options, data, from_hl_group_name, hl_group_name)
  hl_group_name = hl_group_name or from_hl_group_name
  local should_color = options.colored or options.colored == nil

  if not should_color then
    return data
  end

  options.colored = true
  hl_group_name = hl_group_name or from_hl_group_name

  local highlight_color = utils.extract_highlight_colors(from_hl_group_name, 'fg')
  local is_current_window = get_statusline_win() == vim.api.nvim_get_current_win()
  local default_highlight = highlight.format_highlight(
    options.self.section,
    is_current_window
  )
  local section_hl_group_name = options.self.section .. '_' .. hl_group_name

  if not highlight.highlight_exists(section_hl_group_name .. '_normal') then
    section_hl_group_name = highlight.create_component_highlight_group(
      { fg = highlight_color },
      hl_group_name,
      options
    )
  end

  return highlight.component_format_highlight(section_hl_group_name)
    .. data .. default_highlight
end

FileNameWithIcon.init = function(self, options)
  FileNameWithIcon.super.init(self, options)

  if self.component_no then -- If real component and not in case of inheritance
    table.insert(components, self.component_no, self)
  end

  self.options.symbols = vim.tbl_extend(
    'force',
    {modified = '●', readonly = ''},
    self.options.symbols or {}
  )

  self.options = vim.tbl_extend('keep', self.options, {
    readonly = true,
    modified = true,
    modified_icon = false,
  })
end

FileNameWithIcon.get_icon = function(self)
  -- I don't use `self.options.icon` because options are share between instances of the
  -- same component
  -- It was not an issue as long as each component was evaluated was and the result was
  -- added to the statusline.
  -- But now that I evaluate this component on the fly with `%{% %}` it would make all the
  -- windows share the same icon
  local icon, icon_highlight_group = icons_provider:for_buffer(get_statusline_buf())

  if icon and icon_highlight_group then
    icon = add_fg_highlight(self.options, icon, icon_highlight_group)
  end

  return icon or ''
end

FileNameWithIcon.get_filename = function(filename, format)
  filename = filename or buf_get_name()
  format = format or ':~:.'

  if '' == filename then
    filename = '[No Name]'
  elseif filename:match('^fugitive://') then
    filename = vim.fn.fnamemodify(vim.fn.FugitiveReal(filename), format) .. ' [Git]'
  else
    filename = vim.fn.fnamemodify(filename, format)
  end

  return filename
end

FileNameWithIcon.shorten = function(filename)
  local space = math.min(50, math.floor(0.4 * win_get_width()))
  local should_shorten = #filename > space

  return should_shorten and vim.fn.pathshorten(filename) or filename
end

FileNameWithIcon.show_modified = function(self)
  local options = (self or {}).options or {}

  return options.modified and buf_get_option('modified')
end

FileNameWithIcon.highlight_when_modified = function(self, filename)
  if self:show_modified() then
    filename = add_fg_highlight(self.options, filename, 'ErrorMsg', 'modified_buffer')
  end

  return filename
end

FileNameWithIcon.modified_icon = function(self)
  if not self:show_modified() then
    return ''
  end

  local options = (self or {}).options or {}
  if not options.modified_icon then
    return ''
  end

  return add_fg_highlight(self.options, self.options.symbols.modified, 'ErrorMsg', 'buffer_modified')
end

FileNameWithIcon.filename = function(self)
  return self:highlight_when_modified(
    FileNameWithIcon.shorten(
      FileNameWithIcon.get_filename()
    )
  )
end

FileNameWithIcon.readonly = function(self)
  if not self.options.readonly or not buf_get_option('readonly') then
    return ''
  end

  return add_fg_highlight(self.options, self.options.symbols.readonly, 'ErrorMsg', 'readonly_buffer_icon')
end

FileNameWithIcon.update_status = function(self)
  -- This allow the component to be re-evaluated on changes, for instance if I have the
  -- same buffer open in two windows in the same tab.
  -- If I start to modify the buffer in one of the window the status line of the other
  -- window was not updated because lualine freeze the status line of inactive windows
  return string.format(
    "%%{%%luaeval('require([[lualine.components.filename-with-icon]]).render(%d)')%%}",
    self.component_no
  )
end

FileNameWithIcon.render = function(component_no)
  local component = components[component_no]

  return vim.trim(table.concat({
    component:get_icon(),
    component:modified_icon(),
    component:filename(),
    component:readonly(),
  }, ' '))
end

return FileNameWithIcon
