return {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      -- For an explanation of why the validate = { enable = true } option is recommended, see:
      -- https://github.com/b0o/SchemaStore.nvim/issues/8
      validate = { enable = true },
    },
  },
}
