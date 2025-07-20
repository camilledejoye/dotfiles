--- @module lazy
--- @type LazySpec
return {
  'L3MON4D3/LuaSnip',
  build = 'make install_jsregexp',
  event = 'InsertEnter',
  dependencies = {
    'rafamadriz/friendly-snippets',
    'benfowler/telescope-luasnip.nvim',
  },
  config = function()
    -- Too lazy to refactor this file
    -- I should:
    --   * Move the setup into `opts`
    --   * Split the snippets, by filetype, in different files
    --   * Load the snippets here in `config`
    --   * Move the mappings definition (either in `keys` on in `config`)
    require('cdejoye.config.luasnip')
  end,
}
