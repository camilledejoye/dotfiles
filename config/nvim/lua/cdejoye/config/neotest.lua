require('neotest').setup({
  adapters = {
    -- require('neotest-vim-test'),
    require('neotest-plenary'),
    require('neotest-phpunit')({
      phpunit_cmd = function()
        -- To test only, seems again to be hard to run that in a container

        for _, cmd in pairs({"phpunit", "tools/phpunit"}) do
          if 1 == vim.fn.executable(cmd) then
            return cmd
          end
        end

        return "vendor/bin/phpunit"
      end,

      -- dap = {
      --   program = 'vendor/bin/phpunit',
      --   runtimeExecutable = 'docker',
      --   runtimeArgs = vim.tbl_flatten({
      --     'compose', 'exec',
      --     '-e', 'XDEBUG_TRIGGER=1',
      --     '-e', 'XDEBUG_MODE=debug',
      --     'php',
      --   }),
      -- },

      dap = function(_, _, args, _)
        return {
          program = './bin/phpunit',
          args = vim.tbl_flatten({ args, '--dap' }),
          runtimeExecutable = 'bash',
          runtimeArgs = {},
        }
      end,

      path_mappings = {
        -- Keeps empty to use relative paths
        ['/var/www/html'] = '${workspaceFolder}',
      },
    }),
  },
  log_level = vim.log.levels.DEBUG,
  status = {
    enabled = true,
    signs = true,
  },
  quickfix = {
    open = false,
  },
  icons = {
    failed = "",
    passed = "",
    running = "",
    skipped = "",
    unknown = "",
    running_animated = { "\\", "|", "/", "-", "\\", "|", "/", "-" },
    -- running_animated = { "⣷", "⣯", "⣟", "⡿", "⢿", "⣻", "⣽", "⣾" },
  },
})
vim.keymap.set('n', '<Leader>tS', require('neotest').summary.toggle)
vim.keymap.set('n', '<Leader>tn', require('neotest').run.run)
vim.keymap.set('n', '<Leader>tdn', function()
  require('neotest').run.run({ strategy = 'dap' })
end)
vim.keymap.set('n', '<Leader>ta', require('neotest').run.attach)
vim.keymap.set('n', '<Leader>tx', require('neotest').run.stop)
vim.keymap.set('n', '<Leader>tf', function()
  require('neotest').run.run(vim.fn.expand('%'))
end)
vim.keymap.set('n', '<Leader>tl', require('neotest').run.run_last)
vim.keymap.set('n', '<Leader>tdl', function()
  require('neotest').run.run_last({ strategy = 'dap' })
end)

-- Theming
local function customize_theme()
  local hi = require('cdejoye.utils').hi
  local colors = require('base16-colorscheme').colors

  hi('NeotestFailed', { guifg = colors.base08 })
  hi('NeotestPassed', { guifg = colors.base0B })
  hi('NeotestRunning', { guifg = colors.base0A })
  hi('NeotestSkipped', { guifg = colors.base0D })
  hi('NeotestWinSelect', { guifg = colors.base0D, gui = 'bold' })
  hi('NeotestExpandMarker', { guifg = colors.base0F })
  hi('NeotestFocused', { guifg = colors.base05, gui = 'bold,underline' })
  hi('NeotestIndent', { guifg = colors.base03 })
  hi('NeotestMarked', { guifg = colors.base09, gui = 'bold' })
  hi('NeotestNamespace', { guifg = colors.base0E })

  hi('NeotestAdapterName', 'NeotestFailed')
  hi('NeotestTarget', 'NeotestFailed')
  hi('NeotestFile', 'NeotestSkipped')
  hi('NeotestDir', 'NeotestSkipped')
  hi('NeotestBorder', 'FloatBorder')
end

local test_group = vim.api.nvim_create_augroup('cdejoye_test_theme', { clear = true })
vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
  pattern = 'base16-*',
  group = test_group,
  callback = customize_theme,
})
