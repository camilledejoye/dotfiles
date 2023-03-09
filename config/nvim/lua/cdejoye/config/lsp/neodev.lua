local M = {}

function M.setup()
  if pcall(require, 'neodev') then
    -- Must be setup before lspconfig
    require('neodev').setup({
      -- Using a list like that was suggested somewhere, I can't recall where
      -- But it ended up putting `lua.` in front of every `require` I made which was failing when running nvim
      -- while necessary during dev to get completion so I don't do it again dude ;)
      -- library = {
      --   plugins = { 'neotest', 'nvim-dap-ui', 'nvim-lspconfig', 'plenary.nvim' },
      -- },
      override = function(root_dir, library) -- To have it enabled when working on plugins
        if root_dir:match('^'..vim.fs.normalize('~/work/vim/plugins')) then
          library.plugins = true
        end
      end,
    })
  end
end

return M
