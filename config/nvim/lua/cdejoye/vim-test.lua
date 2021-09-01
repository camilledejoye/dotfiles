local g = vim.g
local map = require('cdejoye.utils').map

require('packer').use {
  'vim-test/vim-test',
  { "rcarriga/vim-ultest", requires = {"vim-test/vim-test"}, run = ":UpdateRemotePlugins" },
}

-- Disabled the possibility to run a test from it's source file
-- g['test#no_alternate'] = 1 " Ex.: Don't run tests on save from the sources
g['test#php#behat#use_suite_in_args'] = 1

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

g.ultest_use_pty = 1 -- Act like an interactive session
g.ultest_output_on_line = 0 -- Disable showing output on CursorHold

-- map('<Leader>tf', ':TestFile<CR>')
-- map('<Leader>tn', ':TestNearest<CR>')
-- map('<Leader>ts', ':TestSuite<CR>')
-- map('<Leader>tl', ':TestLast<CR>')
-- map('<Leader>tv', ':TestVisit<CR>')

local opts = { noremap = false }
map('<Leader>tf', '<Plug>(ultest-run-file)', 'n', opts)
map('<Leader>tn', '<Plug>(ultest-run-nearest)', 'n', opts)
map('<Leader>to', '<Plug>(ultest-output-jump)', 'n', opts)
map('<Leader>ts', '<Plug>(ultest-summary-jump)', 'n', opts)
-- Override default mapping used for tags (I don't use tags)
map('[t', '<Plug>(ultest-prev-fail)', 'n', opts)
map(']t', '<Plug>(ultest-next-fail)', 'n', opts)

vim.cmd([[
augroup cdejoye_vim_test
  autocmd!
  autocmd BufWritePost * UltestNearest
augroup END
]])
