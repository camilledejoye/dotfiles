--- @module lazy
--- @type LazySpec[]
return {
  { 'vhyrro/luarocks.nvim', priority = 1000, config = true },
  { 'milisims/nvim-luaref', event = 'VeryLazy' }, -- Add documentation around Lua
  { 'b0o/schemastore.nvim', event = 'VeryLazy' }, -- used by jsonls server to retrieve json schemas
}
