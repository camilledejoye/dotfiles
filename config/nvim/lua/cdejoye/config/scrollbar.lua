if pcall(require, 'gitsigns.highlight') then
  -- Needed for the highlight group to be created in time
  require('gitsigns.highlight').setup_highlights()
end

local signs = require('cdejoye.icons')

require('scrollbar').setup({
  marks = {
    GitAdd = {
      text = signs.git.add,
    },
    GitChange = {
      text = signs.git.change,
    },
    GitDelete = {
      text = signs.git.delete,
    },
    Error = {
      text = { signs.diagnostics.error, signs.diagnostics.error },
    },
    Warn = {
      text = { signs.diagnostics.warn, signs.diagnostics.warn },
    },
    Info = {
      text = { signs.diagnostics.info, signs.diagnostics.info },
    },
    Hint = {
      text = { signs.diagnostics.hint, signs.diagnostics.hint },
    },
  },
  handlers = {
    cursor = false,
    gitsigns = true,
  },
})
