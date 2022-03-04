local bo = vim.bo
local map = require('cdejoye.utils').map

bo.tabstop = 2
bo.softtabstop = bo.tabstop
bo.shiftwidth = bo.tabstop
bo.comments = ':---,:--'

map('<Leader>tf', '<Plug>PlenaryTestFile>', 'n', { noremap = false })
map('<Leader>tl', '<Plug>PlenaryTestFile>', 'n', { noremap = false })
map('<Leader>tn', '<Plug>PlenaryTestFile>', 'n', { noremap = false })
