local highlight = require('lualine.highlight')

-- The component can't be created with at least these options
-- So I need to provide them even just to extend the component
local LspDiagnostics = require('lualine.components.diagnostics'):extend()

LspDiagnostics.init = function(self, options)
  if nil == options.sources then
    options.sources = { 'nvim_diagnostic' }
  end

  LspDiagnostics.super.init(self, options)

  if self.options.colored then -- I like to have background colored for these
    -- TODO follow https://github.com/hoob3rt/lualine.nvim/pull/311
    -- Instead of generating the highlight groups I can provide my own colors if none are
    -- provided
    -- This will allow me to shortcut the default values which can't be overridden
    local section_highlight_map = {x = 'c', y = 'b', z = 'a'}
    local theme = require(('lualine.themes.' .. (self.options.theme or 'auto')))
    local section = self.options.self.section:match('lualine_(.*)')

    if 'c' < section and not theme.normal[section] then
      section = section_highlight_map[section]
    end

    -- Define both background and foreground colors so that it's not impacted by the mode
    local colors = { fg = theme.normal[section].fg }
    local function colors_with_bg(bg)
      return vim.tbl_extend('force', colors, { bg = bg })
    end

    self.highlight_groups = {
      error = highlight.create_component_highlight_group(
        colors_with_bg(self.options.diagnostics_color.error.fg), 'diagnostics_error',
        self.options),
      warn = highlight.create_component_highlight_group(
        colors_with_bg(self.options.diagnostics_color.warn.fg), 'diagnostics_warn',
        self.options),
      info = highlight.create_component_highlight_group(
        colors_with_bg(self.options.diagnostics_color.info.fg), 'diagnostics_info',
        self.options),
      hint = highlight.create_component_highlight_group(
        colors_with_bg(self.options.diagnostics_color.hint.fg), 'diagnostics_hint',
        self.options)
    }
  end
end

return LspDiagnostics
