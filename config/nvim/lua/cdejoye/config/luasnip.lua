local luasnip = require('luasnip')
local types = require('luasnip.util.types')
local snippet = luasnip.snippet
local snippet_node = luasnip.snippet_node
local indent = luasnip.indent_snippet_node
local text = luasnip.text_node
local insert = luasnip.insert_node
local func = luasnip.function_node
local choice = luasnip.choice_node
local dynamic = luasnip.dynamic_node

luasnip.config.setup {
  history = true,
  -- Update more often, :h events for more info.
  updateevents = "TextChanged,TextChangedI",
  -- Disable while I'm still using UltiSnips (no need for LSP)
  -- store_selection_keys = '<Tab>',
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = {{"●", "TSError"}}
      }
    },
    [types.insertNode] = {
      active = {
        virt_text = {{"●", "TSMethod"}}
      }
    }
  },

  -- treesitter-hl has 100, use something higher (default is 200).
  ext_base_prio = 300,
  -- minimal increase in priority.
  ext_prio_increase = 1,
  enable_autosnippets = true,
}

luasnip.snippets = {
  all = {},

  -- Disable for now, I will keep using UltiSnips to limit the amount of work
  -- And only use luasnip for LSP snippets since I can't manage to make UltiSnips works
  -- properly in this situation
  -- php = {
  --   Add handling for abstract !
  --   snippet({ trig = 'm(;?)([uoi])(s?)', regTrig = true }, {
  --     func(function(args)
  --       local visibility = args[1].captures[2]
  --       return 'u' == visibility and 'public '
  --         or 'o' == visibility and 'protected '
  --         or 'i' == visibility and 'private '
  --     end, {}),
  --     func(function(args)
  --       return 's' == args[1].captures[3] and 'static ' or ''
  --     end, {}),
  --     text('function '),
  --     insert(1, 'method'),
  --     text('('),
  --     insert(2),
  --     text(')'),
  --     insert(3, ': void'),
  --     dynamic(4, function(args)
  --       if ';' == args[1].captures[1] then
  --         return snippet_node(nil, text(';'))
  --       end

  --       return snippet_node(nil, {
  --         text({ '', '{' }),
  --         text({ '', '\t' }),
  --         func(function(args2)
  --           return args2[1].env.TM_SELECTED_TEXT
  --         end, {}),
  --         insert(1), -- Can't use insert(0) here sadly
  --         text({ '', '}' }),
  --       })
  --     end, {}),
  --   })
  -- },
}

luasnip.autosnippets = {
  all = {
    -- snippet('autotrigger', { text('autosnippet') }),
  },

  php = {
    -- snippet(',t', text('$this->')),
    -- snippet(',r', { text('return '), insert(1), text(';'), insert(0) }),
  }
}

-- Disable while I'm still using UltiSnips
-- require('luasnip.loaders.from_vscode').lazy_load() -- Load snippets from friendly-snippets

-- Disable since I don't think LSP snippet will be parsed into choices
-- This is just a POC from the github repository, it needs a bit of work to avoid having
-- windows floating indefinitely
-- local current_nsid = vim.api.nvim_create_namespace("LuaSnipChoiceListSelections")
-- local current_win = nil

-- local function window_for_choiceNode(choiceNode)
--   local buf = vim.api.nvim_create_buf(false, true)
--   local buf_text = {}
--   local row_selection = 0
--   local row_offset = 0
--   local docstring
--   for _, node in ipairs(choiceNode.choices) do
--     docstring = node:get_docstring()
--     -- find one that is currently showing
--     if node == choiceNode.active_choice then
--       -- current line is starter from buffer list which is length usually
--       row_selection = #buf_text
--       -- finding how many lines total within a choice selection
--       row_offset = #docstring
--     end
--     vim.list_extend(buf_text, docstring)
--   end

--   vim.api.nvim_buf_set_text(buf, 0,0,0,0, buf_text)
--   local w, h = vim.lsp.util._make_floating_popup_size(buf_text)

--   -- adding highlight so we can see which one is been selected.
--   local extmark = vim.api.nvim_buf_set_extmark(buf,current_nsid,row_selection ,0,
--     {hl_group = 'incsearch',end_line = row_selection + row_offset})

--   -- shows window at a beginning of choiceNode.
--   local win = vim.api.nvim_open_win(buf, false, {
--     relative = "win", width = w, height = h, bufpos = choiceNode.mark:pos_begin_end(), style = "minimal", border = 'rounded'})

--   -- return with 3 main important so we can use them again
--   return {win_id = win,extmark = extmark,buf = buf}
-- end

-- function choice_popup(choiceNode)
--   -- build stack for nested choiceNodes.
--   if current_win then
--     vim.api.nvim_win_close(current_win.win_id, true)
--     vim.api.nvim_buf_del_extmark(current_win.buf,current_nsid,current_win.extmark)
--   end
--   local create_win = window_for_choiceNode(choiceNode)
--   current_win = {
--     win_id = create_win.win_id,
--     prev = current_win,
--     node = choiceNode,
--     extmark = create_win.extmark,
--     buf = create_win.buf
--   }
-- end

-- function update_choice_popup(choiceNode)
--   if current_win then
--     vim.api.nvim_win_close(current_win.win_id, true)
--     vim.api.nvim_buf_del_extmark(current_win.buf,current_nsid,current_win.extmark)
--   end

--   local create_win = window_for_choiceNode(choiceNode)
--   current_win.win_id = create_win.win_id
--   current_win.extmark = create_win.extmark
--   current_win.buf = create_win.buf
-- end

-- function choice_popup_close()
--   if not current_win then
--     return
--   end

--   vim.api.nvim_win_close(current_win.win_id, true)
--   vim.api.nvim_buf_del_extmark(current_win.buf,current_nsid,current_win.extmark)
--   -- now we are checking if we still have previous choice we were in after exit nested choice
--   current_win = current_win.prev
--   if current_win then
--     -- reopen window further down in the stack.
--     local create_win = window_for_choiceNode(current_win.node)
--     current_win.win_id = create_win.win_id
--     current_win.extmark = create_win.extmark
--     current_win.buf = create_win.buf
--   end
-- end

-- vim.cmd([[
-- augroup choice_popup
-- au!
-- au User LuasnipChoiceNodeEnter lua choice_popup(require("luasnip").session.event_node)
-- au User LuasnipChoiceNodeLeave lua choice_popup_close()
-- au User LuasnipChangeChoice lua update_choice_popup(require("luasnip").session.event_node)
-- augroup END
-- ]])
