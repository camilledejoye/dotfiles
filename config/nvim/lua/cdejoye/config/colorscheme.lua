local vim_dir = vim.fn.fnamemodify(vim.env.MYVIMRC, ':h')
local colorschemeFile = vim_dir .. '/colorscheme.vim'
local hi = require('cdejoye.utils').hi

if vim.fn.filereadable(colorschemeFile) then
  vim.cmd('source '.. colorschemeFile)
else
  vim.cmd('colorscheme base16-tomorrow-night')
end

local colors = require('base16-colorscheme').colors
local cursorline = colors.base01
local visual = colors.base02
local comment = colors.base03
local blue = colors.base0D

-- Setup the color for floating windows
hi('FloatBorder', { guifg = blue })

hi('EndOfBuffer', { guifg = 'bg' }) -- Hide the ~ in the number column
hi('VertSplit', { guifg = visual }) -- Color of the border between vertival splits

hi('LineNr', { guifg = comment }) -- Color of the line numbers
hi('CursorLineNr', { guifg = blue, guibg = 'bg' }) -- Color of the current line number

hi('Pmenu', { guifg = comment, guibg = cursorline, gui = 'italic' }) -- Completion menu
hi('PmenuSel', { guifg = blue, guibg = 'bg', gui = 'bold' }) -- Selected item
hi('PmenuSbar', 'Pmenu') -- Completion menu scrollbar
hi('PmenuThumb', { guibg = visual }) -- Completion menu scrollbar's button
-- Custom ones to use for floating window showing documentation during completion
hi('PmenuBorder', 'PmenuInvisibleBorder')
-- Hide the borders by using the same fg and bg but keep the padding having by using borders
hi('PmenuInvisibleBorder', { guifg = cursorline, guibg = cursorline })

hi('CmpItemAbbrMatch', { guifg = blue, gui = 'bold' })

hi('yamlTSField', 'TSKeyword')
