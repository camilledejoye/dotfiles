--- @module lazy
--- @type LazySpec
return {
  'vim-test/vim-test',
  init = function()
    -- Disabled the possibility to run a test from it's source file
    -- g['test#no_alternate'] = 1 " Ex.: Don't run tests on save from the sources
    vim.g['test#php#behat#use_suite_in_args'] = 1
    -- For Worldia because we don't have a file matching the default glob pattern:
    -- features/bootstrap/**/*.php
    vim.g['test#php#behat#bootstrap_directory'] = '*'
    vim.g['test#php#behat#nearest_use_exact_regex'] = 1

    -- Don't run *Test.php with codeception
    vim.g['test#php#codeception#file_pattern'] = [[\v((c|C)e(p|s)t\.php$|\.feature$)]]

    -- Ignore data provider which have to be public methods too
    vim.g['test#php#phpunit#patterns'] = {
      test = {
        [[\v^\s*public function (test\w+)\(]],
        [[\v^\s*\*\s*(\@test)]],
      },
      namespace = {},
    }
    -- If `phpunit` is in the PATH (custom script) then use this instead
    if vim.fn.executable('phpunit') then
      vim.g['test#php#phpunit#executable'] = 'phpunit'
    end
    -- g['test#php#phpunit#options'] = '--testdox' -- Use testdox format for PHPUnit

    -- If `phpspec` is in the PATH (custom script) then use this instead
    if vim.fn.executable('phpspec') then
      vim.g['test#php#phpspec#executable'] = 'phpspec'
    end
    vim.g['test#php#phpspec#options'] = {
      nearest = '--format=pretty --verbose',
      all = '--format=pretty',
      suite = '--format=progress',
    }

    -- If `behat` is in the PATH (custom script) then use this instead
    if vim.fn.executable('behat') then
      vim.g['test#php#behat#executable'] = 'behat'
    end

    vim.g['test#strategy'] = 'neovim'
    vim.g.ultest_loaded = 1
  end,
  keys = {
    { '<Leader>tf', '<cmd>TestFile<CR>' },
    { '<Leader>tn', '<cmd>TestNearest<CR>' },
    { '<Leader>ts', '<cmd>TestSuite<CR>' },
    { '<Leader>tl', '<cmd>TestLast<CR>' },
    { '<Leader>tv', '<cmd>TestVisit<CR>' },
  },
}
