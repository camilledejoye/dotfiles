local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')
local cond = require('nvim-autopairs.conds')
local utils = require('nvim-autopairs.utils')

npairs.setup({
  fast_wrap = {},
})

-- https://github.com/windwp/nvim-autopairs/wiki/Custom-rules#alternative-version
-- Add rules to insert space before closing bracket when inserting one after opening bracket
-- Add rules to only remove the spaces instead of all the bracket pair when pressing <del>
local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
npairs.add_rules({
  Rule(' ', ' ')
    :with_pair(function(opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({
        brackets[1][1] .. brackets[1][2],
        brackets[2][1] .. brackets[2][2],
        brackets[3][1] .. brackets[3][2],
      }, pair)
    end)
    :with_move(cond.none())
    :with_cr(cond.none())
    :with_del(function(opts)
      local col = vim.api.nvim_win_get_cursor(0)[2]
      local context = opts.line:sub(col - 1, col + 2)
      return vim.tbl_contains({
        brackets[1][1] .. '  ' .. brackets[1][2],
        brackets[2][1] .. '  ' .. brackets[2][2],
        brackets[3][1] .. '  ' .. brackets[3][2],
      }, context)
    end),
})
for _, bracket in pairs(brackets) do
  Rule('', ' ' .. bracket[2])
    :with_pair(cond.none())
    :with_move(function(opts)
      return opts.char == bracket[2]
    end)
    :with_cr(cond.none())
    :with_del(cond.none())
    :use_key(bracket[2])
end

-- https://github.com/windwp/nvim-autopairs/wiki/Custom-rules#move-past-commas-and-semicolons
-- Add rules to pass through commas and semicolons
-- The space is a personal addition, to remove if it causes issues (#DontKnowWhatImDoing)
for _, punct in pairs({ ',', ';' }) do
  npairs.add_rules({
    Rule('', punct)
      :with_move(function(opts)
        return opts.char == punct
      end)
      :with_pair(cond.none())
      :with_del(cond.none())
      :with_cr(cond.none())
      :use_key(punct),
  })
end

local function trim(text)
  return text:match('^%s*(.-)%s*$')
end

-- https://github.com/windwp/nvim-autopairs/issues/167#issuecomment-1089688919
-- Add rules to go to the next closing pair in multi-line context (with no text in between)
local function multiline_close_jump(open, close)
  return Rule(close, '')
    :with_pair(function()
      local row, col = utils.get_cursor(0)
      local line = utils.text_get_current_line(0)

      if #line ~= col then --not at EOL
        return false
      end

      local unclosed_count = 0
      for c in line:gmatch('[\\' .. open .. '\\' .. close .. ']') do
        if c == open then
          unclosed_count = unclosed_count + 1
        end
        if unclosed_count > 0 and c == close then
          unclosed_count = unclosed_count - 1
        end
      end
      if unclosed_count > 0 then
        return false
      end

      local nextrow = row + 1
      if nextrow < vim.api.nvim_buf_line_count(0) and vim.regex('^\\s*' .. close):match_line(0, nextrow) then
        return true
      end
      return false
    end)
    :with_move(cond.none())
    :with_cr(cond.none())
    :with_del(cond.none())
    :set_end_pair_length(0)
    :replace_endpair(function(opts)
      local cleanup = '' == trim(opts.line) and 'dd' -- test
        or 'xj' --test
      return ('<esc>%s0f%sa'):format(cleanup, opts.char)
    end)
end

npairs.add_rules({
  multiline_close_jump('(', ')'),
  multiline_close_jump('[', ']'),
  multiline_close_jump('{', '}'),
})
