--- @module lazy
--- @type LazySpec
return { -- Improved increment/decrement
  'monaqa/dial.nvim',
  keys = {
    {
      '<C-a>',
      '<Plug>(dial-increment)',
      mode = { 'n', 'v' },
      desc = 'Increment with dial.nvim',
    },
    {
      '<C-x>',
      '<Plug>(dial-decrement)',
      mode = { 'n', 'v' },
      desc = 'Increment with dial.nvim',
    },
  },
}
