local highlight = require('lualine.highlight')

-- The component can't be created with at least these options
-- So I need to provide them even just to extend the component
local LspDiagnostics = require('lualine.components.diagnostics'):new {
  sources = 'nvim_lsp',
  colored = false,
}

LspDiagnostics.new = function(self, options, child)
  if nil == options.sources then
    options.sources = { 'nvim_lsp' }
  end

  local this = self._parent:new(options, child or LspDiagnostics)

  if this.options.colored then -- I like to have background colored for these
    -- TODO follow https://github.com/hoob3rt/lualine.nvim/pull/311
    -- Instead of generating the highlight groups I can provide my own colors if none are
    -- provided
    -- This will allow me to shortcut the default values which can't be overridden
    local section_highlight_map = {x = 'c', y = 'b', z = 'a'}
    local theme = require(('lualine.themes.' .. (this.options.theme or 'auto')))
    local section = this.options.self.section:match('lualine_(.*)')

    if 'c' < section and not theme.normal[section] then
      section = section_highlight_map[section]
    end

    -- Define both background and foreground colors so that it's not impacted by the mode
    local colors = { fg = theme.normal[section].fg }
    local function colors_with_bg(bg)
      return vim.tbl_extend('force', colors, { bg = bg })
    end

    this.highlight_groups = {
      error = highlight.create_component_highlight_group(
        colors_with_bg(this.options.color_error), 'diagnostics_error',
        this.options),
      warn = highlight.create_component_highlight_group(
        colors_with_bg(this.options.color_warn), 'diagnostics_warn',
        this.options),
      info = highlight.create_component_highlight_group(
        colors_with_bg(this.options.color_info), 'diagnostics_info',
        this.options),
      hint = highlight.create_component_highlight_group(
        colors_with_bg(this.options.color_hint), 'diagnostics_hint',
        this.options)
    }
  end

  return this
end

return LspDiagnostics
