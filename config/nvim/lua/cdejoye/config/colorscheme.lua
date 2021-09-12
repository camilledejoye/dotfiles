local vim_dir = vim.fn.fnamemodify(vim.env.MYVIMRC, ':h')
local colorschemeFile = vim_dir .. '/colorscheme.vim'
local hi = require('cdejoye.utils').hi

if vim.fn.filereadable(colorschemeFile) then
  vim.cmd('source '.. colorschemeFile)
else
  vim.cmd('colorscheme base16-tomorrow-night')
end

local colors = require('base16-colorscheme').colors

-- Setup the color for floating windows' borders
hi('FloatBorder', 'Directory')

hi('EndOfBuffer', { guifg = colors.base00 }) -- Hide the ~ in the number column
hi('VertSplit', { guifg = colors.base01 }) -- Color of the border between vertival splits

hi('LineNr', { guifg = colors.base03 }) -- Color of the line numbers
hi('CursorLineNr', { guifg = colors.base0D, guibg = colors.base00 }) -- Color of the current line number

hi('Pmenu', { guifg = colors.base03, guibg = colors.base01, gui = 'italic' }) -- Completion menu
hi('PmenuSel', { guifg = colors.base0D, guibg = colors.base00, gui = 'bold' }) -- Selected item
hi('PmenuSbar', 'Pmenu') -- Completion menu scrollbar
hi('PmenuThumb', { guibg = colors.base02 }) -- Completion menu scrollbar's button

-- hi('Pmenu', { guifg = colors.base03, guibg = colors.base01, gui = 'italic' }) -- Completion menu
-- hi('PmenuSel', { guifg = colors.base01, guibg = colors.base0D, gui = 'italic,bold' }) -- Selected item
-- hi('PmenuSbar', 'Pmenu') -- Completion menu scrollbar
-- hi('PmenuThumb', { guibg = colors.base02 }) -- Completion menu scrollbar's button
