-- Disable some mappings because I don't use them and they conflict with others
vim.g.nremap = {
  ['=p'] = '<skip>',
  ['=P'] = '<skip>',
  ['[u'] = '<skip>',
  [']u'] = '<skip>',
  ['[uu'] = '<skip>',
  [']uu'] = '<skip>',
  ['[CC'] = '<skip>',
  [']CC'] = '<skip>',
}
