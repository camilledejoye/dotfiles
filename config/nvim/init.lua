local g = vim.g
local opt = vim.opt
local cmd = vim.cmd
local fn = vim.fn
local vim_dir = fn.fnamemodify(vim.env.MYVIMRC, ':h')

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
opt.wildignore:append({'*/.git/*', '*/vendor/*', '*/node_modules/*', '*/var/*', '*/web/build/*'})
opt.textwidth = 90
opt.hidden = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.laststatus = 2
opt.modelines = 5
opt.ts = 4
opt.sts = 4
opt.sw = 4
opt.expandtab = true
opt.listchars:append({ tab = '» ', eol = '¬' })
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.joinspaces = false
opt.display:append({ 'lastline' })
opt.splitright = true
opt.scrolloff = 3
opt.diffopt:append({ 'vertical' })
opt.wildmenu = true
opt.inccommand = 'nosplit'
opt.termguicolors = true

-- Setup packer command to use it as an optional plugin
cmd [[command! PackerInstall packadd packer.nvim | lua require('cdejoye.plugins').install()]]
cmd [[command! PackerUpdate packadd packer.nvim | lua require('cdejoye.plugins').update()]]
cmd [[command! PackerSync packadd packer.nvim | lua require('cdejoye.plugins').sync()]]
cmd [[command! PackerClean packadd packer.nvim | lua require('cdejoye.plugins').clean()]]
cmd [[command! PackerCompile packadd packer.nvim | lua require('cdejoye.plugins').compile()]]

-- cmd([[source /home/cdejoye/.config/nvim/config/50-fzf.vim]])
require('cdejoye.mappings') -- Load custom mappings

-- Jump to the last position we were when we closed the file the last time
cmd([[
augroup cdejoye_custom_commands
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "keepjumps normal g`\"" | endif
augroup END
]])
