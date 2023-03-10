local impatient_ok, impatient = pcall(require, 'impatient')
if impatient_ok then impatient.enable_profile() end

local g = vim.g
local opt = vim.opt
local cmd = vim.cmd
local fn = vim.fn
local vim_dir = fn.fnamemodify(vim.env.MYVIMRC, ':h')

require('cdejoye.disable-plugins')

-- Add global dump() function for debug purpose
function _G.dump(...)
  local args = {...}

  for _, arg in ipairs(args) do
      print(vim.inspect(arg))
  end
end

cmd('filetype plugin indent on')
cmd('syntax on')

g.mapleader = ' '

opt.runtimepath:append({ vim_dir .. '/templates' })
opt.path:append({ '**' })
opt.autochdir = false
-- File in wildignore won't be previwed by telescope
opt.wildignore:append({'*/.git/*', '*/node_modules/*', '*/var/*', '*/web/build/*'})
opt.textwidth = 90
opt.hidden = true
opt.swapfile = false
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.laststatus = 2
opt.modelines = 1
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.breakindent = true -- Wrapped lines continue with the same indentation
opt.showbreak = string.rep(' ', 2) -- Wrapped lines continue with a few more spaces after the indentation
opt.linebreak = true -- Wrap lines at predefined characters for better rendering
opt.listchars:append({ tab = '» ', eol = '¬' })
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.joinspaces = false
opt.display:append({ 'lastline' })
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 3
opt.diffopt:append({ 'vertical', 'hiddenoff', 'algorithm:minimal' })
opt.wildmenu = true
opt.inccommand = 'nosplit'
opt.termguicolors = true
opt.equalalways = true -- automatically resize windows
opt.updatetime = 1000 -- Make updates happen faster
opt.mouse = 'n'
opt.formatoptions = opt.formatoptions
  - 'a' -- Do not auto format
  - 't' -- Do not auto wrap text
  - 'o' -- Do not continue comments on new lines with o and O
  + 'r' -- Auto add comment prefix when pressing <CR> in insert mode
  + 'c' -- Auto wrap text in comment
  + 'j' -- Remove comment prefix when joining lines
  + 'q' -- Format comments with gq
  + 'n' -- Auto indent in numbered lists
  - '2' -- Don't have special paragraph formatting, does play well with 'n'

require('cdejoye.plugins')

-- cmd([[source /home/cdejoye/.config/nvim/config/50-fzf.vim]])
require('cdejoye.mappings') -- Load custom mappings

-- Jump to the last position we were when we closed the file the last time
cmd([[
augroup cdejoye_custom_commands
  autocmd BufReadPost * if 'gitcommit' != &filetype && line("'\"") > 0 && line("'\"") <= line("$") | execute "keepjumps normal g`\"" | endif
augroup END
]])
