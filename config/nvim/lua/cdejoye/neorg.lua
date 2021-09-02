-- https://github.com/vhyrro/neorg/tree/unstable
require('packer').use {
  'vhyrro/neorg',
  branch = 'unstable',
  requires = { 'nvim-lua/plenary.nvim', 'vhyrro/neorg-telescope' },
  -- Don't use `after` because it does not work, instead use after/ftplugin/norg.lua
  -- after = 'nvim-treesitter',
}
