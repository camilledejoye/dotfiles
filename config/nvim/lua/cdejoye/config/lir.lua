local actions = require('lir.actions')
local clipboard_actions = require('lir.clipboard.actions')
local bookmark_actions = require('lir.bookmark.actions')
local mark_actions = require('lir.mark.actions')
local bmap = require('cdejoye.utils').bmap

require('lir').setup({
  show_hidden_files = false,
  ignore = {}, -- { ".DS_Store", "node_modules" } etc.
  on_init = function() end,
  get_filters = function()
    return {}
  end,
  devicons = {
    enable = true,
    highlight_dirname = true,
  },
  mappings = {
    ['l'] = actions.edit,
    ['<C-s>'] = actions.split,
    ['<C-v>'] = actions.vsplit,
    ['<C-t>'] = actions.tabedit,

    ['h'] = actions.up,
    ['q'] = actions.quit,

    ['K'] = actions.mkdir,
    ['N'] = actions.newfile,
    ['R'] = actions.rename,
    ['@'] = function()
      local current_dir = require('lir.vim').get_context().dir
      vim.cmd('silent lcd ' .. current_dir)
      print('lcd: ' .. current_dir)
    end,
    ['Y'] = actions.yank_path,
    ['.'] = actions.toggle_show_hidden,
    ['D'] = actions.delete,

    ['J'] = function()
      mark_actions.toggle_mark('n')
      vim.cmd('normal! j')
    end,
    ['C'] = clipboard_actions.copy,
    ['X'] = clipboard_actions.cut,
    ['P'] = clipboard_actions.paste,

    ['M'] = bookmark_actions.add,
    ['B'] = bookmark_actions.list,
  },
  float = {
    winblend = 0,

    -- You can define a function that returns a table to be passed as the third
    -- argument of nvim_open_win().
    win_opts = function()
      local width = math.floor(vim.o.columns * 0.8)
      local height = math.floor(vim.o.lines * 0.8)

      return { border = 'rounded', width = width, height = height }
    end,

    curdir_window = { enable = false, highlight_dirname = false },
  },
  hide_cursor = true,
})

-- The buffer should probably have a nofile type and be configured
-- to be invisible by the user, PR ?
local function delete_bookmark_buffer(decorated_fn)
  return function()
    local bufnr = vim.api.nvim_get_current_buf()
    decorated_fn()
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end
end

require('lir.bookmark').setup({
  bookmark_path = vim.fn.stdpath('data') .. '/lir_bookmarks',
  mappings = {
    ['l'] = delete_bookmark_buffer(bookmark_actions.edit),
    ['<C-s>'] = bookmark_actions.split,
    ['<C-v>'] = bookmark_actions.vsplit,
    ['<C-t>'] = bookmark_actions.tabedit,
    ['@'] = function()
      local dir = vim.api.nvim_get_current_line()
      vim.cmd('silent lcd ' .. dir)
      print('lcd: ' .. dir)
    end,
    ['D'] = function()
      vim.cmd('delete | w')
    end,
    ['B'] = delete_bookmark_buffer(bookmark_actions.open_lir),
    ['h'] = delete_bookmark_buffer(bookmark_actions.open_lir),
    ['q'] = delete_bookmark_buffer(bookmark_actions.open_lir),
  },
})

vim.cmd([[
augroup cdejoye_lir
  autocmd!
  autocmd Filetype lir :lua require('cdejoye.config.lir').on_attach(vim.api.nvim_get_current_buf())
augroup END
]])

return {
  on_attach = function(bufnr)
    bmap(bufnr, 'J', [[:<C-u>lua require('lir.mark.actions').toggle_mark('v')<CR>]], 'x')
    bmap(bufnr, '-', [[:<C-u>lua require('lir.actions').up()<CR>]])
  end,
}
