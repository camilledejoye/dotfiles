-- vim: ts=2 sw=2 et fdm=marker

local use = require('packer').use

use('neovim/nvim-lspconfig')

-- nvim-lsp {{{

-- LSP settings
local nvim_lsp = require('lspconfig')
local on_attach = function(_, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<C-w><C-]>', [[<cmd>lua require('cdejoye.lsp').buf.definition('vsplit')<CR>]], opts)
  buf_set_keymap('n', '<C-A-]>', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<C-w><C-A-]>', [[<cmd>lua require('cdejoye.lsp').buf.type_definition('vsplit')<CR>]], opts)
  buf_set_keymap('n', 'gdd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gdD', [[<cmd>lua require('cdejoye.lsp').buf.definition('vsplit')<CR>]], opts)
  buf_set_keymap('n', 'gdi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gdI', [[<cmd>lua require('cdejoye.lsp').buf.implementation('vsplit')<CR>]], opts)
  buf_set_keymap('n', 'gdt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gdT', [[<cmd>lua require('cdejoye.lsp').buf.type_definition('vsplit')<CR>]], opts)
  buf_set_keymap('n', 'gdr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gdR', [[<cmd>lua require('cdejoye.lsp').buf.references('vsplit')<CR>]], opts)

  buf_set_keymap('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- buf_set_keymap('v', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>od', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  -- buf_set_keymap('n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
  buf_set_keymap('n', '<Leader>ff', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Enable the following language servers
local servers = { 'phpactor' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- }}}

-- sumneko/lua-language-server {{{

local sumneko_root_path = vim.fn.getenv 'HOME' .. '/lsp/server/lua-language-server' -- Change to your sumneko root installation
local sumneko_binary = sumneko_root_path .. '/bin/Linux/lua-language-server'

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require('lspconfig').sumneko_lua.setup {
  cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

-- }}}

-- nvim-cmp {{{

use {
  'hrsh7th/nvim-cmp',
  requires = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'onsails/lspkind-nvim',
    'hrsh7th/cmp-nvim-lsp',
    -- Use UltiSnips instead until I fixed the mappings and adapt all my snippets
    -- 'saadparwaiz1/cmp_luasnip',
    -- 'L3MON4D3/LuaSnip',
    'quangnguyen30192/cmp-nvim-ultisnips',
    'hrsh7th/cmp-emoji',
    'f3fora/cmp-spell',
  },
}

local cmp = require('cmp')
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

-- local function select_or_jump_prev()
--   return function(fallback)
--     if not cmp.select_prev_item() then
--       luasnip_jump_prev()(fallback)
--     end
--   end
-- end

-- local function select_or_jump_next()
--   return function(fallback)
--     if not cmp.select_next_item() then
--       luasnip_jump_next()(fallback)
--     end
--   end
-- end

vim.o.completeopt = 'menu,menuone,noselect'

local sources = {
  buffer = '[Buffer]',
  path = '[Path]',
  neorg = '[Neorg]',
  -- luasnip = '[LuaSnip]',
  ultisnips = '[UltiSnips]',
  nvim_lsp = '[LSP]',
  emoji = '[Emoji]',
  spell = '[Spell]',
}
cmp.setup {
  snippet = {
    expand = function(args)
      -- require('luasnip').lsp_expand(args.body)
      vim.fn['UltiSnips#Anon'](args.body)
    end,
  },
  mapping = {
    -- ['<C-p>'] = cmp.mapping(select_or_jump_prev(), { 'i', 's' }),
    -- ['<C-n>'] = cmp.mapping(select_or_jump_next(), { 'i', 's' }),
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
  sources = vim.tbl_map(function(source)
    return { name = source }
  end, vim.tbl_keys(sources)),
  formatting = {
    format = function(entry, vim_item)
      -- fancy icons and a name of kind
      vim_item.kind = require('lspkind').presets.default[vim_item.kind] .. ' ' .. vim_item.kind

      -- set a name for each source
      vim_item.menu = sources[entry.source.name]

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

-- }}}

require('cdejoye/trouble')
