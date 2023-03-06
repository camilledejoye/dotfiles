-- Lua
local actions = require('diffview.actions')

require('diffview').setup({
  enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
  view = {
    default = {
      winbar_info = true, -- See ':h diffview-config-view.x.winbar_info'
    },
    merge_tool = {
      winbar_info = true, -- See ':h diffview-config-view.x.winbar_info'
    },
    file_history = {
      winbar_info = true, -- See ':h diffview-config-view.x.winbar_info'
    },
  },
  keymaps = {
    disable_defaults = false, -- Disable the default keymaps
    view = {
      -- The `view` bindings are active in the diff buffers, only when the current
      -- tabpage is a Diffview.
      { 'n', '[n', actions.prev_conflict, { desc = 'In the merge-tool: jump to the previous conflict' }, },
      { 'n', ']n', actions.next_conflict, { desc = 'In the merge-tool: jump to the next conflict' } },
    },
    file_panel = {
      { 'n', '[n', actions.prev_conflict, { desc = 'Go to the previous conflict' } },
      { 'n', ']n', actions.next_conflict, { desc = 'Go to the next conflict' } },
    },
  },
})
