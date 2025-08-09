--- @module lazy
--- @type LazySpec[]
return {
  {
    'tpope/vim-surround',
    init = function()
      vim.g.surround_no_insert_mappings = true
    end,
  },
  { 'tpope/vim-scriptease', cmd = 'Scriptnames' },
  {
    'tpope/vim-unimpaired',
    config = function()
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
        -- ['[n'] = '<skip>',
        -- [']n'] = '<skip>',
      }
    end,
  },
  'tpope/vim-abolish',
  'tpope/vim-commentary',
  -- Try to remove it to see what I might used by habits but don't remember it came from this plugin
  -- { 'tpope/vim-fugitive', lazy = false, keys = { { '<Leader>gb', ':Git blame<CR>' } } },
  'tpope/vim-repeat',
  'tpope/vim-dispatch',
  'radenling/vim-dispatch-neovim',
  {
    'tpope/vim-projectionist',
    config = function()
      require('cdejoye.config.projectionist')
    end,
  },
  'tpope/vim-eunuch',
}
