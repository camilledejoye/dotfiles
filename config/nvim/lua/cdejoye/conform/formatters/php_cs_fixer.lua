local utils = require('cdejoye.utils')

---@type conform.FileFormatterConfig
return {
  command = function()
    return utils.find_executable('php-cs-fixer', {
      'tools',
      'tools/php-cs-fixer/vendor/bin',
      'vendor/bin',
    })
  end,
  args = { 'fix', '$RELATIVE_FILEPATH' },
  ---@param self conform.FormatterConfig
  ---@param ctx conform.Context
  condition = function(self, ctx)
    local root_dir = self:cwd(ctx)
    local bufname_match = function(glob)
      glob = root_dir..'/'..glob

      return vim.regex(vim.fn.glob2regpat(glob)):match_str(ctx.filename)
    end

    return not(
      bufname_match('vendor/*')
      or bufname_match('var/*')
      -- or bufname_match('tests/*')
    )
  end,
}
