local cmp = require('cmp')

-- Name of the sources as keys and text to show in the completion menu as values
-- The order helps define the source priority, see `sorting.priority_weight` options
local sources = {
  nvim_lsp = { name = 'nvim_lsp', label = '[LSP]' },
  neorg = { name = 'neorg', label = '[Neorg]' },
  path = { name = 'path', label = '[Path]' },
  -- luasnip = { name = 'luasnip', label = '[LuaSnip]' },
  ultisnips = { name = 'ultisnips', label = '[UltiSnips]' },
  buffer = { name = 'buffer', label = '[Buffer]', opts = { get_bufnrs = function()
    return vim.api.nvim_list_bufs()
  end} },
  spell = { name = 'spell', label = '[Spell]' },
  emoji = { name = 'emoji', label = '[Emoji]' },
}

vim.o.completeopt = 'menu,menuone,noselect'

-- local luasnip = require('luasnip')

-- local function luasnip_jump_prev()
--   return function(fallback)
--     if not luasnip.jump(-1) then
--       fallback()
--     end
--   end
-- end

-- local function luasnip_jump_next()
--   return function(fallback)
--     if not luasnip.jump(1) then
--       fallback()
--     end
--   end
-- end

-- local function select_or_choose_or_jump_prev()
--   return function(fallback)
--     if not cmp.select_prev_item() then
--       if luasnip.choice_active() then
--         luasnip.change_choice(-1)
--       else
--         luasnip_jump_prev()(fallback)
--       end
--     end
--   end
-- end

-- local function select_or_choose_or_jump_next()
--   return function(fallback)
--     if not cmp.select_next_item() then
--       if luasnip.choice_active() then
--         luasnip.change_choice(1)
--       else
--         luasnip_jump_next()(fallback)
--       end
--     end
--   end
-- end

cmp.setup {
  sources = vim.tbl_values(sources),

  snippet = {
    expand = function(args)
      -- luasnip.lsp_expand(args.body)
      vim.fn['UltiSnips#Anon'](args.body)
    end,
  },

  mapping = {
    -- ['<C-p>'] = cmp.mapping(select_or_choose_or_jump_prev(), { 'i', 's' }),
    -- ['<C-n>'] = cmp.mapping(select_or_choose_or_jump_next(), { 'i', 's' }),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    -- ['<Tab>'] = function(fallback)
    --   if not luasnip.expand() then
    --     fallback()
    --   end
    -- end,
    -- ['<C-k>'] = cmp.mapping(luasnip_jump_prev(), { 'i', 's' }),
    -- ['<C-j>'] = cmp.mapping(luasnip_jump_next(), { 'i', 's' }),
  },

  documentation = {
    border = 'rounded',
    winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder',
  },

  formatting = {
    format = function(entry, vim_item)
      -- fancy icons and a name of kind
      local item_kinds = require('vim.lsp.protocol').CompletionItemKind
      local kind_num = item_kinds[vim_item.kind]
      vim_item.kind = item_kinds[kind_num]

      -- set a name for each source
      vim_item.menu = sources[entry.source.name].label

      -- set the detail as menu
      if 'nvim_lsp' == entry.source.name then
        if 'phpactor' == entry.source.source.client.name then
          vim_item.menu = entry.completion_item.detail .. ' ' .. vim_item.menu
        end
      end

      return vim_item
    end,
  },
}
