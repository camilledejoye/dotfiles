require('noice').setup({
  cmdline = {
    view = 'cmdline',
  },
  messages = {
    enabled = true,
    view = 'mini',
  },
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
    signature = { enabled = false },
    documentation = {
      opts = {
        border = 'single', -- no round borders
      },
    },
  },
  views = {
    -- -- override the default split view to always enter the split when it opens
    -- split = { enter = true },
  },
  routes = {
    -- { -- routes long errors and warning to the popup for inspection
    --   view = 'popup',
    --   filter = {
    --     event = 'msg_show',
    --     any = {
    --       { error = true, min_height = 10 },
    --       { error = true, min_width = 120 },
    --       { warning = true, min_height = 10 },
    --       { warning = true, min_width = 120 },
    --     },
    --   },
    -- }
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    -- inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },
})

if pcall(require, 'telescope') then
  require('telescope').load_extension('noice');
end

-- Scroll in documentation
vim.keymap.set({ 'n', 'i', 's' }, '<c-f>', function()
  if not require('noice.lsp').scroll(4) then
    return '<c-f>'
  end
end, { silent = true, expr = true })
vim.keymap.set({ 'n', 'i', 's' }, '<c-d>', function()
  if not require('noice.lsp').scroll(4) then
    return '<c-d>'
  end
end, { silent = true, expr = true })

vim.keymap.set({ 'n', 'i', 's' }, '<c-b>', function()
  if not require('noice.lsp').scroll(-4) then
    return '<c-b>'
  end
end, { silent = true, expr = true })
vim.keymap.set({ 'n', 'i', 's' }, '<c-u>', function()
  if not require('noice.lsp').scroll(-4) then
    return '<c-u>'
  end
end, { silent = true, expr = true })

-- use Shift + Enter to show the result of a command printing somthing into a popup instead of the usual
-- notify window
vim.keymap.set("c", "<S-Enter>", function()
  require("noice").redirect(vim.fn.getcmdline())
end, { desc = "Redirect Cmdline" })

-- Theming
local hi = require('cdejoye.utils').hi
hi('NoiceConfirmBorder', 'FloatBorder')
hi('NoiceCmdlinePopupBorder', 'FloatBorder')
