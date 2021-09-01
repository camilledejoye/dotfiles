local g = vim.g

require('packer').use { 'vimwiki/vimwiki', opt = true }

g.vimwiki_map_prefix = '<Leader>n'
g.vimwiki_list = {
  {
      path = '~/.local/share/vimwiki/',
      syntax = 'markdown',
      ext = '.md',
      auto_toc = 1,
      links_space_char = '-',
      auto_diary_index = 1,
  },
  {
      path = '~/vimwiki/',
      syntax = 'markdown',
      ext = '.md',
      auto_toc = 1,
      links_space_char = '-',
      auto_diary_index = 1,
  },
}

-- Vimwiki has a feature called "Temporary Wikis", that will treat every file
-- with configured file-extension as a wiki.
g.vimwiki_global_ext = 0 -- .md files are not automatically considered as a wiki

vim.api.nvim_set_keymap(
  'n',
  '<Leader>nw',
  ':unmap <Leader>nw<BAR>packadd vimwiki<BAR>VimwikiTabIndex<CR>',
  { noremap = true, silent = true }
)

-- vim: ts=2 sw=2 et fdm=marker
