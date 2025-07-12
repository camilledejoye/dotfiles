return {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          enabled = true,
          maxLineLength = 120,
        },
        rope_completion = { enabled = true },
        rope_autoimport = { enabled = true },
      },
    },
  },
}
