local function cmd_exists(cmd)
  local result = os.execute('command -v ' .. cmd)

  if true ~= result and 0 ~= result then
    return false
  end

  return true
end

local function is_server_installed()
  if cmd_exists('diagnostic-languageserver') then
    return true
  end

  print('diagnostic-languageserver is not installed, please run: yarn global add diagnostic-languageserver')

  return false
end

if is_server_installed() then
  require('lspconfig').diagnosticls.setup {
    filetypes = { 'php' },
    init_options = {
      linters = {
        phpcs = {
          command = './vendor/bin/phpcs',
          debounce = 100,
          rootPatterns = { 'composer.json', 'composer.lock', 'vendor', '.git' },
          args = { '--standard=PSR2', '--report=emacs', '-s', '-' },
          offsetLine = 0,
          offsetColumn = 0,
          sourceName = 'phpcs',
          formatLines = 1,
          formatPattern = {
            '^.*:(\\d+):(\\d+):\\s+(.*)\\s+-\\s+(.*)(\\r|\\n)*$',
            {
              line = 1,
              column = 2,
              message = 4,
              security = 3,
            },
          },
          securities = {
            error = 'error',
            warning = 'warning',
          },
        },
      },
      phpstan = {
        command = './vendor/bin/phpstan',
        debounce = 100,
        rootPatterns = { 'composer.json', 'composer.lock', 'vendor', '.git' },
        args = { 'analyze', '--error-format', 'raw', '--no-progress', '%file' },
        offsetLine = 0,
        offsetColumn = 0,
        sourceName = 'phpstan',
        formatLines = 1,
        formatPattern = {
          '(\\d+):(.*)(\\r|\\n)*$',
          {
            line = 1,
            message = 2,
          },
        },
      },
      shellcheck = {
        command = 'shellcheck',
        debounce = 100,
        args = { '--format', 'json', '-' },
        sourceName = 'shellcheck',
        parseJson = {
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          message = '${message} [${code}]',
          security = 'level',
        },
        securities = {
          error = 'error',
          warning = 'warning',
          info = 'info',
          style = 'hint',
        },
      },
    },
  }
end
