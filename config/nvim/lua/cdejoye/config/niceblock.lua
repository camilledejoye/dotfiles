local map = require('cdejoye.utils').map

-- Needed because targets.vim use I and A to improve text objects
-- It replaces the default gI mapping from niceblock but I usually don't need it
map('gI', '<Plug>(niceblock-I)', 'v', { noremap = false })
map('gA', '<Plug>(niceblock-A)', 'v', { noremap = false })
