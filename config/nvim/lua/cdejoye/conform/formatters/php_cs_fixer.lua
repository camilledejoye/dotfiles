local utils = require('cdejoye.utils')

---@type conform.FileFormatterConfig
return {
  meta = {
    url = "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer",
    description = "The PHP Coding Standards Fixer.",
  },
  command = function()
    return utils.find_executable('php-cs-fixer', {
      'tools',
      'tools/php-cs-fixer/vendor/bin',
      'vendor/bin',
    })
  end,
  args = {
    'fix',
    '--using-cache=no',
    '--show-progress=none',
    '--no-interaction',
    '--path-mode=intersection', -- prevents formatting files excluded from php-cs-fixer config
    '$RELATIVE_FILEPATH',
  },
  -- Must not use filename starting with a dot (default is ".conform.$RANDOM.$FILENAME")
  -- Otherwise php-cs-fixer, with --path-mode=interaction, will ignore it
  tmpfile_format = 'Conform-$RANDOM-$FILENAME',
  -- The default is to look for composer.json
  -- The reason I need to look for `.git` first, is the mono-repo
  -- We have the same style rules for all projects in it
  -- So the config file is at the git root not project root.
  -- Mono-repo which choose to keep different settings would benefit from the other default
  cwd = function(_, ctx)
    return vim.fs.root(ctx.dirname, { { '.git' }, { 'composer.json' } })
  end
}
