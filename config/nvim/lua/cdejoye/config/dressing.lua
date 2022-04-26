local config = {
  input = {
    border = 'single', -- try "solid": adds padding by a single whitespace cell
    winblend = 0, -- I don't like transparency
    insert_only = false,
  },
  select = {
    builtin = {
      border = 'single', -- try "solid": adds padding by a single whitespace cell
      winblend = 0, -- I don't like transparency
    },
  },
}

local is_telescope_loaded, telescope_themes = pcall('require', 'telescope.themes')
if is_telescope_loaded then
  config.select.telescope = telescope_themes.get_cursor({})
end

require('dressing').setup(config)

local group = vim.api.nvim_create_augroup('cdejoye_dressing_input_mappings', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = 'DressingInput',
  desc = 'Define mappings for DressingInput FileType buffers',
  callback = function(args)
    local bufnr = args.buf
    local ibmap = function(lhs, rhs)
      vim.api.nvim_buf_set_keymap(bufnr, 'i', lhs, rhs, { silent = true, noremap = true })
    end

    ibmap('<C-k>', [[<cmd>lua require('dressing.input').history_prev()<CR>]])
    ibmap('<C-j>', [[<cmd>lua require('dressing.input').history_next()<CR>]])
  end,
})
