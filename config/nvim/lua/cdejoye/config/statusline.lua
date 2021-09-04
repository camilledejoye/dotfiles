local statusline = require('cdejoye.statusline')
local hi = statusline.hi

vim.o.showmode = false
vim.o.showtabline = 2

local function setup_colors(colorscheme)
  local ok, base16 = pcall(require, 'base16-colorscheme')

  if not ok then
    return
  end

  local colors = colorscheme and base16.colorschemes[colorscheme] or base16.colorschemes['tomorrow-night']

  statusline.setup_colors()

  hi.StatuslineNormalMode = { guifg = colors.base02, guibg = colors.base0D, gui = 'bold' }
  hi.StatuslineInsertMode = { guifg = colors.base02, guibg = colors.base0A, gui = 'bold' }
  hi.StatuslineVisualMode = { guifg = colors.base02, guibg = colors.base0E, gui = 'bold' }
  hi.StatuslineReplaceMode = { guifg = colors.base02, guibg = colors.base09, gui = 'bold' }
  hi.StatuslineCommandMode = { guifg = colors.base02, guibg = colors.base0D, gui = 'bold' }
  hi.StatuslineTerminalMode = { guifg = colors.base02, guibg = colors.base0A, gui = 'bold' }
  hi.StatuslineMiscMode = { guifg = colors.base02, guibg = colors.base0F, gui = 'bold' }
  hi.StatuslineFilenameNotModified = { guifg = colors.base05, guibg = colors.base01, gui = 'none' }
  hi.StatuslineFilenameModified = { guifg = colors.base08, guibg = colors.base01, gui = 'none' }
  hi.StatuslineVC = { guifg = colors.base05, guibg = colors.base02, gui = 'none' }
  hi.StatuslineDiagnosticsError = { guifg = colors.base02, guibg = colors.base08, gui = 'bold' }
  hi.StatuslineDiagnosticsWarning = { guifg = colors.base02, guibg = colors.base09, gui = 'bold' }
  hi.StatuslineDiagnosticsInfo = { guifg = colors.base02, guibg = colors.base0D, gui = 'bold' }
  hi.StatuslineDiagnosticsHint = { guifg = colors.base02, guibg = colors.base0C, gui = 'bold' }
  hi.StatuslineRadOnly = { guifg = colors.base08, guibg = colors.base01, gui = 'bold' }
end

setup_colors()

vim.cmd([[
augroup cdejoye_statusline
  autocmd!
  autocmd VimEnter * ++once lua statusline = require('cdejoye.statusline')
  autocmd VimEnter * ++once lua vim.o.statusline = '%!v:lua.statusline.status()'

  autocmd ColorScheme * lua require('cdejoye.config.statusline').setup_colors('<amatch>')
augroup END
]])

return { setup_colors = setup_colors }
