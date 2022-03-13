local bo = vim.bo
local map = require("cdejoye.utils").map

bo.tabstop = 2
bo.softtabstop = bo.tabstop
bo.shiftwidth = bo.tabstop
bo.comments = ":---,:--"

vim.cmd([[
function! CdejoyePlenaryTestHarnessFile(testfile)
  let l:opts = {}
  let l:minimal_init = findfile('minimal_init.vim', '**')

  if empty(l:minimal_init)
    let l:opts['minimum'] = v:true
  else
    let l:opts['minimal_init'] = l:minimal_init
  endif

  call luaeval("require('plenary.test_harness').test_directory(_A[1], _A[2])", [a:testfile, l:opts])
endfunction
]])

local test_current_file = [[
<cmd>call CdejoyePlenaryTestHarnessFile(expand('%:p'))<CR>
]]
map("<Leader>tf", test_current_file, "n", { noremap = false })
map("<Leader>tl", test_current_file, "n", { noremap = false })
map("<Leader>tn", test_current_file, "n", { noremap = false })
