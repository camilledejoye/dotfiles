-- vim: ts=2 sw=2 et

local g = vim.g
local opt = vim.opt
local cmd = vim.cmd
local vimDirectory = vim.api.nvim_eval("fnamemodify(resolve(expand('<sfile>')), ':p:h')")

function _G.dump(...)
  local args = {...}

  for _, arg in ipairs(args) do
      print(vim.inspect(arg))
  end
end

cmd('filetype plugin indent on')
cmd('syntax on')

g.mapleader = ','
g.my_vim_dir = vimDirectory

opt.runtimepath:append({ vimDirectory .. '/templates' })
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

-- Load the plugins
require('cdejoye/plugins')
require('cdejoye/ale')
require('cdejoye/alignment')
require('cdejoye/auto-pairs')
require('cdejoye/colorizer')
require('cdejoye/colorscheme')
require('cdejoye/command')
require('cdejoye/debug')
require('cdejoye/editorconfig')
require('cdejoye/explorer')
-- vim.cmd [[source /home/cdejoye/.config/nvim/config/50-fzf.vim]]
require('cdejoye/gitgutter')
require('cdejoye/git-messenger')
require('cdejoye/mappings')
require('cdejoye/nvim-lsp')
-- TODO test it to make sure it's correctly configured
-- require('cdejoye/diagnosticls')
require('cdejoye/php')
require('cdejoye/phpactor')
require('cdejoye/snippets')
vim.cmd [[source /home/cdejoye/.config/nvim/config/50-statusline.vim]]
require('cdejoye/telescope')
require('cdejoye/tpope')
require('cdejoye/treesitter')
require('cdejoye/vim-argwrap')
require('cdejoye/vim-closetag')
require('cdejoye/vim-javascript')
require('cdejoye/vim-plugin-viewdoc')
require('cdejoye/vim-test')
require('cdejoye/vim-vimwiki')

local use = require('packer').use

-- Plugin to fix CursorHold performance issue on Neovim:
-- https://github.com/antoinemadec/FixCursorHold.nvim
-- See: https://github.com/neovim/neovim/issues/12587
use {
  "antoinemadec/FixCursorHold.nvim",
  run = function()
    vim.g.curshold_updatime = 1000
  end,
}

-- Add documentation around Lua
use 'nanotee/luv-vimdocs'
use 'milisims/nvim-luaref'

-- To use icons from nonicons font
use {
  'yamatsum/nvim-nonicons',
  requires = {'kyazdani42/nvim-web-devicons'}
}

use 'monaqa/dial.nvim' -- Improved increment/decrement (including markdown titles)

-- TODO check https://github.com/lukas-reineke/indent-blankline.nvim
-- TODO check https://github.com/folke/trouble.nvim
-- To add floating signature when typing: https://github.com/ray-x/lsp_signature.nvim
-- Add info from LSP to status bar: https://github.com/nvim-lua/lsp-status.nvim
-- TODO check https://github.com/ms-jpq/coq_nvim (completion supposed to be fast)

-- Could be interesting:
-- https://github.com/folke/zen-mode.nvim
-- https://github.com/folke/twilight.nvim
