local g = vim.g

require('packer').use('jiangmiao/auto-pairs')

-- Mappings
-- '' to disable the mapping
g.AutoPairsShortcutToggle = ''
g.AutoPairsShortcutFastWrap = ''
g.AutoPairsShortcutJump = ''
g.AutoPairsShortcutBackInsert = ''
-- Conflicting mapping, see: after/plugin/conflicting-mappings.vim
g.AutoPairsMapBS = 0

-- Fly Mode will always force closed-pair jumping instead of inserting
-- Only for ')', '}', ']'
-- Might be confusing at first but I want to gave it a fair try
-- It's nice in some circumstances but disturbing most of the time
-- g.AutoPairsFlyMode = 1

g.AutoPairsCenterLine = 0 -- Prevent `zz` when splitting pairs on multiple lines

vim.cmd([[
augroup cdejoye_autopairs
autocmd!
" Disable autopairs in telescope prompt
autocmd FileType TelescopePrompt let b:autopairs_enabled = 0
augroup END
]])
