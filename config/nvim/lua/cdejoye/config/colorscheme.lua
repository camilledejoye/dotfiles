-- Tweaks the colors to my taste with a base16 theme
local function customize_theme()
  local colors = require('base16-colorscheme').colors
  local cursorline = colors.base01
  local visual = colors.base02
  local comment = colors.base03
  local blue = colors.base0D

  local hi = require('cdejoye.utils').hi

  hi('FloatBorder', { guifg = blue })

  hi('EndOfBuffer', { guifg = 'bg' }) -- Hide the ~ in the number column
  hi('VertSplit', { guifg = visual }) -- Color of the border between vertival splits

  hi('LineNr', { guifg = comment }) -- Color of the line numbers
  hi('CursorLineNr', { guifg = blue, guibg = 'bg' }) -- Color of the current line number

  hi('Pmenu', { guifg = comment, guibg = cursorline, gui = 'italic' }) -- Completion menu
  hi('PmenuSel', { guifg = 'none', guibg = 'bg', gui = 'bold' }) -- Selected item
  hi('PmenuSbar', 'Pmenu') -- Completion menu scrollbar
  hi('PmenuThumb', { guibg = visual }) -- Completion menu scrollbar's button
  -- Custom ones to use for floating window showing documentation during completion
  hi('PmenuBorder', 'PmenuInvisibleBorder')
  -- Hide the borders by using the same fg and bg but keep the padding having by using borders
  hi('PmenuInvisibleBorder', { guifg = cursorline, guibg = cursorline })

  hi('CmpItemAbbrMatch', { guifg = blue, gui = 'bold' })

  hi('yamlTSField', 'TSKeyword')
end

local colorschemes = {
  -- 'base16-decaf',
  -- 'base16-eighties',
  -- 'base16-espresso',
  -- 'base16-material',
  -- 'base16-oceanicnext',
  -- 'base16-one-light',
  'base16-onedark',
  'base16-tomorrow-night',
  -- 'base16-tomorrow-night-eighties',
}

local notification_id
local function load_colorscheme(colorscheme)
  vim.cmd(string.format('colorscheme %s', colorscheme))
  notification_id = vim.notify(colorscheme, vim.log.levels.INFO, {
    summary = 'Colorscheme loaded',
    replaces_id = notification_id,
    timeout = 1000,
  })
end

local index = 0
vim.keymap.set('n', '<C-Left>', function()
  index = index <= 1 and #colorschemes or index - 1
  load_colorscheme(colorschemes[index])
end, {
    silent = true,
    noremap = true,
    desc = 'Select the previous colorscheme',
  })

vim.keymap.set('n', '<C-Right>', function()
  index = #colorschemes == index and 1 or index + 1
  load_colorscheme(colorschemes[index])
end, {
    silent = true,
    noremap = true,
    desc = 'Select the next colorscheme',
  })

local augroup = vim.api.nvim_create_augroup('cdejoye_base16_colorscheme', {})
vim.api.nvim_create_autocmd('Colorscheme', {
  callback = customize_theme,
  pattern = 'base16-*',
  group = augroup,
})

local vim_dir = vim.fn.fnamemodify(vim.env.MYVIMRC, ':h')
local colorschemeFile = vim_dir .. '/colorscheme.vim'

if vim.fn.filereadable(colorschemeFile) then
  vim.cmd('source '.. colorschemeFile)
else
  vim.cmd('colorscheme base16-tomorrow-night')
end
