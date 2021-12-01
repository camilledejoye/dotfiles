local cmp = require('cmp')

vim.o.completeopt = 'menu,menuone,noselect'

cmp.setup {
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'path' },
    { name = 'buffer', option = {
      get_bufnrs = function()
        local bufs = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          bufs[vim.api.nvim_win_get_buf(win)] = true
        end
        return vim.tbl_keys(bufs)
      end
    }, keyword_length = 5 },
    { name = 'spell', keyword_length = 5 },
    { name = 'emoji' },
    { name = 'ultisnips' },
    { name = 'neorg' },
  }),

  sorting = {
    comparators = {
      -- Should help prioritizing suggestions closer to the current position
      function(...) return require('cmp_buffer'):compare_locality(...) end,
    },
  },

  snippet = {
    expand = function(args)
      -- luasnip.lsp_expand(args.body)
      vim.fn['UltiSnips#Anon'](args.body)
    end,
  },

  mapping = {
    ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }),
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
      -- vim_item.menu = source_names[entry.source.name]
      vim_item.menu = ({
        buffer = '[Buffer]',
        nvim_lsp = '[LSP]',
        luasnip = '[LuaSnip]',
        ultisnips = '[UltiSnips]',
        nvim_lua = '[Lua]',
        latex_symbols = '[Latex]',
        neorg = '[Neorg]',
      })[entry.source.name]

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

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' },
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path', keyword_length = 5 }
  }, {
    { name = 'cmdline', keyword_length = 5 },
  })
})
