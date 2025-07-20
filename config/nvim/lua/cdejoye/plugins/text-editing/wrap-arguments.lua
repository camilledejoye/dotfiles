--- @module lazy
--- @type LazySpec
return {
  'https://git.sr.ht/~foosoft/argonaut.nvim',
  opts = {
    comma_last = true,
    limit_cols = 512,
    limit_rows = 64,
    by_filetype = {
      json = { comma_last = false },
    },
  },
  cmd = { 'ArgonautToggle' },
  keys = {
    {
      'gaw',
      ':<C-u>ArgonautToggle<CR>',
      desc = 'Wrap/UnWrap arguments',
      noremap = true,
      silent = true,
    },
  },
}
