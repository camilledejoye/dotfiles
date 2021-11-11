local b, bo, wo = vim.b, vim.bo, vim.wo
local bmap = function(...) require('cdejoye.utils').bmap(0, ...) end

local function t(str)
  -- Adjust boolean arguments as needed
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

wo.foldlevel = 1 -- To open classes folds
wo.foldtext = 'MyFoldText()' -- Force vim-cleanfold because php-foldexpr override it
bo.iskeyword = 'a-z,A-Z,48-57,_,128-255' -- Match PHP definition of a word
bo.commentstring = '// %s' -- Default is /* %s */ and it doesn't play well wen comment phpdoc

-- Folds
b.phpfold_use = true
b.phpfold_group_args = false
b.phpfold_doc_with_funcs = false
b.phpfold_doc_fixed_foldlevel = 9

-- Open the word under the cursor with the official PHP documentation website
bmap('<C-k>', [[:silent execute ':!xdg-open https://php.net/en/'. expand('<cword>')<CR>]])

-- Cycle through the different visibilities
bmap('[v', [[<cmd>lua require('cdejoye.php').cycle_visibility(false)<CR>]])
bmap(']v', [[<cmd>lua require('cdejoye.php').cycle_visibility(true)<CR>]])

bmap(',,', '->', 'i')
bmap(',t', '$this->', 'i')
bmap(',r', t('return ;<Esc>i'), 'i')
bmap(',<', t('<?php<CR><CR>'), 'i')

-- Open an interactive PHP session in an emulated terminal
vim.cmd([[command! -buffer Repl botright split term://php\ -a | normal! i]])
