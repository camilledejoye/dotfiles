local actions = require('lir.actions')
local clipboard_actions = require('lir.clipboard.actions')
local mark_actions = require( 'lir.mark.actions')
local map = require('cdejoye.utils').map
local bmap = require('cdejoye.utils').bmap

require'lir'.setup {
  show_hidden_files = false,
  devicons_enable = true,
  mappings = {
    ['l']     = actions.edit,
    ['<C-s>'] = actions.split,
    ['<C-v>'] = actions.vsplit,
    ['<C-t>'] = actions.tabedit,

    ['h']     = actions.up,
    ['q']     = actions.quit,

    ['K']     = actions.mkdir,
    ['N']     = actions.newfile,
    ['R']     = actions.rename,
    ['@']     = actions.cd, -- TODO create a lcd action
    ['Y']     = actions.yank_path,
    ['.']     = actions.toggle_show_hidden,
    ['D']     = actions.delete,

    ['J'] = function()
      mark_actions.toggle_mark()
      vim.cmd('normal! j')
    end,
    ['C'] = clipboard_actions.copy,
    ['X'] = clipboard_actions.cut,
    ['P'] = clipboard_actions.paste,
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
  },
  hide_cursor = true,
}

-- custom folder icon
require'nvim-web-devicons'.setup({
  override = {
    lir_folder_icon = {
      icon = '',
      color = string.format('#%06x', vim.api.nvim_get_hl_by_name('Directory', true).foreground),
      name = 'LirFolderNode'
    },
  }
})

map('-', [[:edit <C-r>=expand('%:p:h')<CR><CR>]])

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
