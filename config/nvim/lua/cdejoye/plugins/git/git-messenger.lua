--- @module lazy
--- @type LazySpec
return {
  'rhysd/git-messenger.vim',
  init = function()
    vim.g.git_messenger_no_default_mappings = false
    vim.g.git_messenger_floating_win_opts = { border = 'rounded' }
    vim.g.git_messenger_popup_content_margins = false
    vim.g.git_messenger_extra_blame_args = '-w'

    local function setup_mappings()
      local bmap = function(...)
        require('cdejoye.utils').bmap(vim.api.nvim_get_current_buf(), ...)
      end
      local opts = { noremap = false }

      bmap('<C-o>', 'o', 'n', opts)
      bmap('<C-i>', 'O', 'n', opts)
    end

    local augroup = vim.api.nvim_create_augroup('cdejoye_git_messenger', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      callback = setup_mappings,
      pattern = 'gitmessengerpopup',
      group = augroup,
      once = false,
    })
  end,
  cmd = { 'GitMessenger' },
  keys = {
    { '<Leader>gm', '<Plug>(git-messenger)' },
  },
}
