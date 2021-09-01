local bufnr = vim.api.nvim_get_current_buf()
local bmap = function(...)
  require('cdejoye.utils').bmap(bufnr, ...)
end

bmap('zk', [[<cmd>lua require('cdejoye.trouble/').previous_fold()<CR>]])
bmap('zj', [[<cmd>lua require('cdejoye.trouble/').next_fold()<CR>]])
