return {
  settings = {
    yaml = {
      format = {
        singleQuote = true,
        proseWrap = 'Always',
        printWidth = 120, -- TODO detect it for YAML config ?
      },
      schemas = {
        ['https://json.schemastore.org/taskfile.json'] = {
          'Taskfile.dist.yaml',
          '*Taskfile.yaml',
          'tasks/*.yml',
          'tasks/*.yaml',
        },
      },
    },
  },
}
