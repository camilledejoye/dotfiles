--- @module lazy
--- @type LazySpec
return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  ---@module "ibl"
  ---@type ibl.config
  opts = {
    indent = {
      char = '▎',
      -- char = '┊',
    },
    scope = {
      show_start = false,
      show_end = false,
      include = {
        node_type = {
          php = { 'compound_statement' }, -- for all blocks: if, for, etc.
        },
      },
    },
  },
}
