require('lspkind').init {
  -- enables text annotations
  --
  -- default: true
  -- with_text = true,

  -- default symbol map
  -- can be either 'default' (requires nerd-fonts font) or
  -- 'codicons' for codicon preset (requires vscode-codicons font)
  --
  -- default: 'default'

  -- override preset symbols
  --
  -- default: {}
  symbol_map = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    -- Field = "ﰠ",
    Field = "",
    Variable = "",
    -- Class = "ﴯ",
    Class = "",
    Interface = "",
    Module = "",
    -- Property = "ﰠ",
    Property = "",
    -- Unit = "塞",
    Unit = "",
    Value = "",
    Enum = "∈",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "e",
    Constant = "",
    -- Struct = "פּ",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = ""
  },
}
