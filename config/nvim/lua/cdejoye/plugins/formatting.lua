local function formatter(name)
  return function()
    local exists, opts = pcall(require, 'cdejoye.conform.formatters.' .. name)

    return exists and opts or {}
  end
end

--- @module lazy
--- @type LazySpec
return {
  {
    'stevearc/conform.nvim',
    dependencies = {
      {
        'zapling/mason-conform.nvim',
        opts = {
          -- Usually installed per project to have specific versions
          ignore_install = { 'phpcbf', 'phpcs', 'phpstan', 'php_cs_fixer' },
        },
      },
    },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<Leader>ff',
        function()
          require('conform').format({ async = true })
        end,
        desc = 'Format buffer',
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      -- log_level = vim.log.levels.DEBUG,
      -- Set default options
      default_format_opts = {
        lsp_format = 'fallback',
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        php = { 'php_cs_fixer' },
        sql = { 'sql_formatter' },
        python = { 'isort', 'black' },
      },
      formatters = {
        php_cs_fixer = formatter('php_cs_fixer'),
      },
    },
  },
}
