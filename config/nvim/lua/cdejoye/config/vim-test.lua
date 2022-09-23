local g = vim.g
local map = require('cdejoye.utils').map

-- Disabled the possibility to run a test from it's source file
-- g['test#no_alternate'] = 1 " Ex.: Don't run tests on save from the sources
g['test#php#behat#use_suite_in_args'] = 1
-- For Worldia because we don't have a file matching the default glob pattern:
-- features/bootstrap/**/*.php
g['test#php#behat#bootstrap_directory'] = '*'
g['test#php#behat#nearest_use_exact_regex'] = 1

-- Don't run *Test.php with codeception
g['test#php#codeception#file_pattern'] = [[\v((c|C)e(p|s)t\.php$|\.feature$)]]

-- Ignore data provider which have to be public methods too
g['test#php#phpunit#patterns'] = {
  test = {
    [[\v^\s*public function (test\w+)\(]],
    [[\v^\s*\*\s*(\@test)]]
  },
  namespace = {},
}
g['test#php#phpunit#options'] = '--testdox' -- Use testdox format for PHPUnit

g['test#php#phpspec#executable'] = 'phpspec'
g['test#php#phpspec#options'] = {
  nearest = '--format=pretty --verbose',
  all = '--format=pretty',
  suite = '--format=progress',
}

g['test#php#behat#executable'] = 'behat'

g['test#strategy'] = 'neovim'
g.ultest_loaded = 1
map('<Leader>tf', ':TestFile<CR>')
map('<Leader>tn', ':TestNearest<CR>')
map('<Leader>ts', ':TestSuite<CR>')
map('<Leader>tl', ':TestLast<CR>')
map('<Leader>tv', ':TestVisit<CR>')

-- -- Disable until I can test it better, I experienced some issues with it so I'll stick
-- -- with the regular vim-test for now
-- g.ultest_use_pty = 1 -- Act like an interactive session
-- g.ultest_output_on_line = 0 -- Disable showing output on CursorHold

-- -- Mappings

-- local opts = { noremap = false }
-- map('<Leader>tF', '<cmd>TestFile<CR>', 'n', opts)
-- map('<Leader>tN', '<cmd>TestNearest<CR>', 'n', opts)
-- map('<Leader>tS', '<cmd>TestSuite<CR>', 'n', opts)
-- map('<Leader>tL', '<cmd>TestLast<CR>', 'n', opts)
-- map('<Leader>tv', '<cmd>TestVisit<CR>', 'n', opts)

-- map('<Leader>tf', '<Plug>(ultest-run-file)', 'n', opts)
-- map('<Leader>tn', '<Plug>(ultest-run-nearest)', 'n', opts)
-- map('<Leader>to', '<Plug>(ultest-output-jump)', 'n', opts)
-- map('<Leader>tl', '<Plug>(ultest-run-last)', 'n', opts)
-- map('<Leader>ts', '<cmd>UltestSummary!<CR>', 'n', opts)
-- map('<Leader>td', '<Plug>(ultest-debug-nearest)', 'n', opts)
-- -- Override default mapping used for tags (I don't use tags)
-- map('[t', '<Plug>(ultest-prev-fail)', 'n', opts)
-- map(']t', '<Plug>(ultest-next-fail)', 'n', opts)

-- -- Debugging

-- require('ultest').setup {
--   builders = {
--     ['php#phpspec'] = function (cmd)
--       -- cmd = docker-compose exec <container> <program> [<action>, ...] <file>:<line>
--       local runtimeExecutable = table.remove(cmd, 1) -- docker-compose
--       local runtimeArgs = {
--         table.remove(cmd, 1), -- exec
--         '-T', -- Needed for dap to be able to execute the command
--         '-e', 'XDEBUG_SESSION=1', -- To trigger a new debugging session
--         table.remove(cmd, 1), -- <container>
--       }
--       local program = table.remove(cmd, 1) -- <program>
--       local args = cmd -- [<action>, ...] <file>:<line>

--       -- pretty junit dot tap
--       table.insert(args, 2, '--no-interaction')

--       return {
--         dap = {
--           type = 'php',
--           request = 'launch',
--           name = 'Ultest PHP',
--           port = 9003,
--           pathMappings = {
--             ['/var/www/html'] = '${workspaceFolder}',
--           },
--           program = program, -- The program to run the tests
--           args = args, -- The arguments to run the test including the file to test
--           runtimeExecutable = runtimeExecutable, -- Replace php executable by docker-compose
--           runtimeArgs = runtimeArgs, -- Arguments for docker-compose
--         },
--         parse_result = function (lines)
--           return nil == string.find(lines[#lines - 2], 'failed', 1, true) and 0 or 1
--         end
--       }
--     end,
--   },
-- }

-- -- vim.cmd([[
-- -- augroup cdejoye_vim_test
-- --   autocmd!
-- --   autocmd BufWritePost * UltestNearest
-- -- augroup END
-- -- ]])
