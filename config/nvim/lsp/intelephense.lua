return {
  init_options = { licenceKey = vim.fn.expand('$HOME/.local/share/intelephense/licence-key') },
  settings = {
    intelephense = {
      files = {
        exclude = {
          '**/.git/**',
          '**/.svn/**',
          '**/.hg/**',
          '**/CVS/**',
          '**/.DS_Store/**',
          '**/node_modules/**',
          '**/bower_components/**',
          '**/vendor/**/{Tests,tests}/**',
          '**/.history/**',
          '**/vendor/**/vendor/**',
          -- Symfony project specific
          '**/var/cache/**',
          '**/var/log/**',
        },
      },
      codeLens = {
        implementations = { enable = true },
        overrides = { enable = true },
        parent = { enable = true },
        references = { enable = true },
        usages = { enable = true },
      },
      compatibility = {
        preferPsalmPhpstanPrefixedAnnotations = true,
      },
    },
  },
}
