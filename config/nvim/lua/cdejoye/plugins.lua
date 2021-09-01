-- vim: ts=2 sw=2 et fdm=marker

local cmd = vim.cmd

cmd [[command! PackerInstall packadd packer.nvim | lua require('cdejoye/plugins').install()]]
cmd [[command! PackerUpdate packadd packer.nvim | lua require('cdejoye/plugins').update()]]
cmd [[command! PackerSync packadd packer.nvim | lua require('cdejoye/plugins').sync()]]
cmd [[command! PackerClean packadd packer.nvim | lua require('cdejoye/plugins').clean()]]
cmd [[command! PackerCompile packadd packer.nvim | lua require('cdejoye/plugins').compile()]]

return require('packer').startup({ function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Miscelanous {{{
  use {
    'camilledejoye/vim-cleanfold',
    'kana/vim-niceblock',
    'terryma/vim-multiple-cursors',
    'junegunn/vader.vim',
  }
  -- }}}

  -- Language related (syntax, completion,e tc.) {{{
  use {
    'elzr/vim-json',
    'othree/csscomplete.vim',
    'camilledejoye/vim-sxhkdrc',
    'cespare/vim-toml',
    'tbastos/vim-lua',
    { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview', ft = 'markdown' },
  }
  -- }}}

  -- Adds a bunch of text objects, especially argument text object
  use 'wellle/targets.vim'

end, config = {
  disable_commands = true,
  package_root = require('packer/util').join_paths(vim.g.my_vim_dir, 'pack'),
  -- auto_clean = false, -- Disable because phpactor is a symlink and it's not handled properly (it seems)
}})
