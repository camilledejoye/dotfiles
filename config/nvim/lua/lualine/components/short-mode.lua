local ShortMode = require('lualine.component'):new()

-- List of mode -> :h mode()
-- Use ony the first letter as recommended by the documentation
-- Use byte code because for some modes it's what we got, for instance with visual block
ShortMode.mode2byte = {
  normal       = 110,
  prompt       = 114,
  command      = 99,
  shell        = 33,
  insert       = 105,
  terminal     = 116,
  visual       = 118,
  visual_line  = 86,
  visual_block = 22,
  replace      = 82,
  select       = 115,
  select_line  = 83,
  select_block = 94,
}

ShortMode.new = function(self, options, child)
  local this = self._parent:new(options, child or ShortMode)

  this.options.mode_text = vim.tbl_extend('keep', this.options.mode_text or {}, {
    [self.mode2byte.normal]       = 'N',
    [self.mode2byte.prompt]       = 'P',
    [self.mode2byte.command]      = 'C',
    [self.mode2byte.shell]        = 'SH',
    [self.mode2byte.insert]       = 'I',
    [self.mode2byte.terminal]     = 'T',
    [self.mode2byte.visual]       = 'V',
    [self.mode2byte.visual_line]  = 'VL',
    [self.mode2byte.visual_block] = 'VB',
    [self.mode2byte.replace]      = 'R',
    [self.mode2byte.select]       = 'S',
    [self.mode2byte.select_line]  = 'SL',
    [self.mode2byte.select_block] = 'SB',
  })

  return this
end

ShortMode.update_status = function (self)
  local mode = vim.api.nvim_get_mode().mode

  return self.options.mode_text[mode:byte()] or mode
end

return ShortMode
