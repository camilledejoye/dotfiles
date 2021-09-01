require('packer').use('rhysd/git-messenger.vim')

local g = vim.g

g.git_messenger_floating_win_opts = { border = 'rounded' }
g.git_messenger_popup_content_margins = false
g.git_messenger_extra_blame_args = '-w'

vim.cmd([[
  augroup cdejoye_git_messenger
    autocmd!
    autocmd FileType gitmessengerpopup lua require('cdejoye.git-messenger').setup()
  augroup END
]])

local M = {}

function M.setup()
  local bmap = function(...)
    require('cdejoye.utils').bmap(vim.api.nvim_get_current_buf(), ...)
  end
  local opts = { noremap = false }

  bmap('<C-o>', 'o', 'n', opts)
  bmap('<C-i>', 'O', 'n', opts)
end

return M
