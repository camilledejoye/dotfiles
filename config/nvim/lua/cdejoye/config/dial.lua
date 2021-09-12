local map = require('cdejoye.utils').map

local opts = { noremap = false }
map('<C-a>', '<Plug>(dial-increment)', 'nv', opts)
map('<C-x>', '<Plug>(dial-decrement)', 'nv', opts)
map('g<C-a>', '<Plug>(dial-increment-additional)', 'v', opts)
map('g<C-x>', '<Plug>(dial-decrement-additional)', 'v', opts)
