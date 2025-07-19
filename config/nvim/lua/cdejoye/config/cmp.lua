local cmp = require('cmp')
local hi = require('cdejoye.utils').hi

vim.o.completeopt = 'menu,menuone,noselect'

hi('CmpItemAbbrMatch', 'TSEmphasis', true)
hi('CmpItemAbbrMatchFuzzy', 'CmpItemAbbrMatch', true)
hi('CmpItemAbbrDeprecated', { gui = 'strikethrough' }, true)
hi('CmpItemKindFunction', 'TSFunction', true)
hi('CmpItemKindMethod', 'TSMethod', true)
hi('CmpItemKindConstructor', 'TSConstructor', true)
hi('CmpItemKindInterface', 'TSType', true)
hi('CmpItemKindClass', 'CmpItemKindInterface', true)
hi('CmpItemKindModule', 'CmpItemKindInterface', true)
hi('CmpItemKindVariable', 'TSVariable', true)
hi('CmpItemKindField', 'TSField', true)
hi('CmpItemKindProperty', 'TSProperty', true)
hi('CmpItemKindConstant', 'TSConstant', true)
hi('CmpItemKindKeyword', 'TSKeyword', true)

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
    { name = 'nerdfont' },
    { name = 'luasnip' },
    { name = 'neorg' },
    {
      name = "lazydev",
      group_index = 0, -- set group index to 0 to skip loading LuaLS completions
    }
  }),

  -- Disable because was actually making it awkward with intelephense
  -- because it prefix some "global" variables to sort them and they were shown first all
  -- the time
  -- sorting = {
  --   comparators = {
  --     -- Should help prioritizing suggestions closer to the current position
  --     function(...) return require('cmp_buffer'):compare_locality(...) end,
  --   },
  -- },

  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },

  mapping = {
    ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }),
  },

  window = {
    documentation = cmp.config.window.bordered({
      border = 'single',
      winhighlight = 'NormalFloat:Pmenu,FloatBorder:PmenuBorder',
    }),
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
        spell = '[Spell]',
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
          -- Check if the completion_item.detail has been removed or just not present on all results
          if entry.completion_item.detail then
            vim_item.menu = entry.completion_item.detail .. ' ' .. vim_item.menu
          end
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
    { name = 'path' }
  }, {
    { name = 'cmdline' },
  })
})
