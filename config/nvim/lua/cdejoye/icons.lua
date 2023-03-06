-- https://www.nerdfonts.com/cheat-sheet
-- Icons starting with nf-fa seems to be more readable with my font size
local icons = {
  check = {
    default = '',
    circle = {
      default = '',
      full = '',
      empty = '',
    },
    square = {
      default = '',
      empty = '',
      full = '',
    },
  },
  uncheck = {
    default = '',
    thin = '',
    thick = '',
    circle = {
      default = '',
      empty = '',
      full = '',
    },
    square = {
      default = '',
      empty = '',
      full = '',
    },
  },
  arrow = {
    default = '➜',
    thin = '➜',
    thick = '',
    circle = {
      default = ''
    }
  },
}

return vim.tbl_extend('force', icons, {
  git = {
    program = "",
    branch = "",
    conflict = "",
    add = "",
    change = "",
    delete = "",
  },
  diagnostics = {
    error = icons.uncheck.circle.full,
    warn = "",
    info = "",
    hint = "",
  },
})

-- Cheat sheet for icons from nerd font which looks nice (faster than the full cheat sheet)
-- local icons = {
--   ActiveLSP = "",
--   ActiveTS = "綠",
--   ArrowLeft = "",
--   ArrowRight = "",
--   BufferClose = "",
--   DapBreakpoint = "",
--   DapBreakpointCondition = "",
--   DapBreakpointRejected = "",
--   DapLogPoint = ".>",
--   DapStopped = "",
--   DefaultFile = "",
--   Diagnostic = "裂",
  -- DiagnosticError = "",
  -- DiagnosticHint = "",
  -- DiagnosticInfo = "",
--   DiagnosticWarn = "",
--   Ellipsis = "…",
--   FileModified = "",
--   FileReadOnly = "",
--   FolderClosed = "",
--   FolderEmpty = "",
--   FolderOpen = "",
--   Git = "",
--   GitAdd = "",
--   GitBranch = "",
--   GitChange = "",
--   GitConflict = "",
--   GitDelete = "",
--   GitIgnored = "◌",
--   GitRenamed = "➜",
--   GitStaged = "✓",
--   GitUnstaged = "✗",
--   GitUntracked = "★",
--   LSPLoaded = "",
--   LSPLoading1 = "",
--   LSPLoading2 = "",
--   LSPLoading3 = "",
--   MacroRecording = "",
--   NeovimClose = "", -- TODO v3: remove this icon
--   Paste = "",
--   Search = "",
--   Selected = "❯",
--   Spellcheck = "暈",
--   TabClose = "",
-- }
