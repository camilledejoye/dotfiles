local b, bo, wo = vim.b, vim.bo, vim.wo
local bmap = function(...) require('cdejoye.utils').bmap(0, ...) end

local function t(str)
  -- Adjust boolean arguments as needed
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

wo.foldlevel = 1 -- To open classes folds
wo.foldtext = 'MyFoldText()' -- Force vim-cleanfold because php-foldexpr override it
bo.iskeyword = 'a-z,A-Z,48-57,_,128-255' -- Match PHP definition of a word
bo.commentstring = '// %s' -- Default is /* %s */ and it doesn't play well when commenting phpdoc

-- Open the word under the cursor with the official PHP documentation website
bmap('<C-k>', [[:silent execute ':!xdg-open https://php.net/en/'. expand('<cword>')<CR>]])

-- Cycle through the different visibilities
bmap('[v', [[<cmd>lua require('cdejoye.php').cycle_visibility(false)<CR>]])
bmap(']v', [[<cmd>lua require('cdejoye.php').cycle_visibility(true)<CR>]])

bmap(',,', '->', 'i')
bmap(',t', '$this->', 'i')
bmap(',r', t('return ;<Esc>i'), 'i')
bmap(',<', t('<?php<CR><CR>'), 'i')

-- Do not continue comments on new lines with o and O
-- The default indent file for php will add it automatically
vim.g.PHP_autoformatcomment = false

-- Enable folds for PHP and set it to start at level 1 in order to have all methods folded
vim.opt.foldenable = true
vim.opt.foldlevelstart = 1

-- Open an interactive PHP session in an emulated terminal
vim.cmd([[command! -buffer Repl botright split term://php\ -a | normal! i]])
