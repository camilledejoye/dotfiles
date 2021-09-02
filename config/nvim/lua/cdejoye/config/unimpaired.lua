-- Disable some mappings because I don't use them and they conflict with others
vim.g.nremap = {
  ['=p'] = '<skip>',
  ['=P'] = '<skip>',
  ['[u'] = '<skip>',
  [']u'] = '<skip>',
  ['[uu'] = '<skip>',
  [']uu'] = '<skip>',
}

-- =o and =op mappings could not be removed this way so I had to deal with them
-- in ../after/plugin/conflicting-mappings.vim
