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
  'onedark',
  'catppuccin',
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

require('cdejoye.config.base16').setup()

local vim_dir = vim.fn.fnamemodify(vim.env.MYVIMRC, ':h')
local colorschemeFile = vim_dir .. '/colorscheme.vim'
if vim.fn.filereadable(colorschemeFile) then
  vim.cmd('source ' .. colorschemeFile)
else
  vim.cmd('colorscheme base16-tomorrow-night')
end
