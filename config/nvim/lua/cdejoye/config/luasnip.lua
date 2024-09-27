local ls = require('luasnip')
local types = require('luasnip.util.types')
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local l = require('luasnip.extras').lambda
local fmt = require('luasnip.extras.fmt').fmt
local postfix = function(context, nodes, opts)
  if 'string' == type(context) then
    context = { trig = context }
  end

  -- Match the full line without the indentation by default
  context = vim.tbl_deep_extend('keep', context, { match_pattern = '^%s*(.+)$' })

  return require('luasnip.extras.postfix').postfix(context, nodes, opts)
end

ls.config.setup({
  history = false,
  -- Update more often, :h events for more info.
  updateevents = 'TextChanged,TextChangedI',
  store_selection_keys = '<Tab>',
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { '●', 'TSMethod' } },
      },
    },
  },

  -- treesitter-hl has 100, use something higher (default is 200).
  ext_base_prio = 300,
  -- minimal increase in priority.
  ext_prio_increase = 1,
  -- Disable since I don't remember what it does, to check
  -- enable_autosnippets = true,

  -- Implement nested placeholders
  -- Doesn't work perfectly(yet): if the entire placeholder is replaced, the nested tabstops won't be skipped.
  parser_nested_assembler = function(_, snippet)
    local select = function(snip, no_move)
      snip.parent:enter_node(snip.indx)
      -- upon deletion, extmarks of inner nodes should shift to end of
      -- placeholder-text.
      for _, node in ipairs(snip.nodes) do
        node:set_mark_rgrav(true, true)
      end

      -- SELECT all text inside the snippet.
      if not no_move then
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
          "n",
          true
        )
        node_util.select_node(snip)
      end
    end
    function snippet:jump_into(dir, no_move)
      if self.active then
        -- inside snippet, but not selected.
        if dir == 1 then
          self:input_leave()
          return self.next:jump_into(dir, no_move)
        else
          select(self, no_move)
          return self
        end
      else
        -- jumping in from outside snippet.
        self:input_enter()
        if dir == 1 then
          select(self, no_move)
          return self
        else
          return self.inner_last:jump_into(dir, no_move)
        end
      end
    end

    -- this is called only if the snippet is currently selected.
    function snippet:jump_from(dir, no_move)
      if dir == 1 then
        return self.inner_first:jump_into(dir, no_move)
      else
        self:input_leave()
        return self.prev:jump_into(dir, no_move)
      end
    end

    return snippet
  end,
})

local function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('force', { noremap = true, silent = true }, opts or {}))
end
local function feedkeys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), 'n', false)
end

map({ 'i', 's' }, '<Tab>', function()
  if ls.expandable() then
    return ls.expand({})
  end

  feedkeys('<Tab>')
end)

map({ 'i', 's' }, '<C-k>', function()
  if ls.jumpable(-1) then
    return ls.jump(-1)
  end

  feedkeys('<C-k>')
end)

map({ 'i', 's' }, '<C-j>', function()
  if ls.jumpable(1) then
    return ls.jump(1)
  end

  feedkeys('<C-j>')
end)

map({ 'i', 's' }, '<C-p>', function()
  if ls.choice_active() then
    return ls.change_choice(-1)
  end

  feedkeys('<C-p>')
end)

map({ 'i', 's' }, '<C-n>', function()
  if ls.choice_active() then
    return ls.change_choice(1)
  end

  feedkeys('<C-n>')
end)

map({ 'i', 's' }, '<C-l>', function()
  if ls.choice_active() then
    require('luasnip.extras.select_choice')()
  end
end)

local function php_visibility(visibility_letter)
  return 'u' == visibility_letter and 'public'
      or 'o' == visibility_letter and 'protected'
      or 'i' == visibility_letter and 'private'
end

local function f_visibility(i)
  return f(function(_, snip)
    return php_visibility(snip.captures[i or 1])
  end)
end

local function f_tm_selected()
  return f(function(_, snip)
    return snip.env.TM_SELECTED_TEXT
  end)
end

local function sn_insert_default_selected(_, snip)
  return sn(nil, {
    f(function()
      return snip.env.TM_SELECTED_TEXT
    end),
    i(1),
  })
end

local function sn_phptag(_, snip)
  local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
  if vim.startswith(first_line, '<?') then
    return sn(nil, t(''))
  end

  return sn(nil, t({ '<?php', '', '' }))
end

local function sn_namespace(_, snip)
  local lines = vim.api.nvim_buf_get_lines(0, 0, tonumber(snip.env.TM_LINE_INDEX), false)
  for _, line in ipairs(lines) do
    if nil ~= line:match('^%s*namespace') then
      return sn(nil, t(''))
    end
  end

  local namespace = vim.fn.exists('*phpactor#GetNamespace') and vim.call('phpactor#GetNamespace')

  return sn(nil, {
    t('namespace '),
    nil ~= namespace and vim.NIL ~= namespace and t(namespace) or i(1),
    t({ ';', '', '' })
  })
end

local function sn_classname(_, _)
  return sn(nil, {
    i(1, vim.fn.expand('%:t:r'))
  })
end

ls.cleanup() -- Needed to reload the snippets when sourcing the file

-- Also reload lazy loaded snippets
vim.tbl_map(
function(type) require("luasnip.loaders.from_" .. type).lazy_load() end,
{ "vscode", "snipmate", "lua" }
)

ls.add_snippets('all', {
  s('date', { f(function()
    return os.date('%Y-%m-%d')
  end) }),
  s('datetime', { f(function()
    return os.date('%Y-%m-%d %T')
  end) }),
})

-- Disable for now, I will keep using UltiSnips to limit the amount of work
-- And only use luasnip for LSP snippets since I can't manage to make UltiSnips works
-- properly in this situation
ls.add_snippets('php', {
  -- Class
  s({ trig = '([af]?)class', regTrig = true }, fmt('{phptag}{namespace}{type}class {name}\n{{\n\t{body}\n}}', {
    phptag = d(1, sn_phptag),
    namespace = d(2, sn_namespace),
    type = f(function(_, snip)
      return 'f' == snip.captures[1] and 'final ' or 'a' == snip.captures[1] and 'abstract ' or ''
    end),
    name = d(3, sn_classname),
    body = d(4, sn_insert_default_selected),
  })),

  -- Interface
  s({ trig = 'interface' }, fmt('{phptag}{namespace}interface {name}\n{{\n\t{body}\n}}', {
    phptag = d(1, sn_phptag),
    namespace = d(2, sn_namespace),
    name = d(3, sn_classname),
    body = d(4, sn_insert_default_selected),
  })),

  -- Constructor
  s(
    { trig = 'c([uoi])', regTrig = true },
    fmt('{visibility} function __construct({args})\n{{\n\t{selected}{body}\n}}', {
        visibility = f_visibility(),
        args = i(1),
        selected = f_tm_selected(),
        body = i(0),
    })
  ),

  -- Property declaration
  s(
    { trig = 'p([uoi])(s?)', regTrig = true },
    fmt('{visibility}{static} {type}${name}{default};', {
      visibility = f_visibility(),
      static = f(function(_, snip)
        return 's' == snip.captures[2] and ' static' or ''
      end),
      type = c(1, {
        sn(nil, { i(1, 'string'), t(' ') }),
        t(''),
      }),
      name = i(2, 'property'),
      default = c(3, {
        t(''),
        sn(nil, { t(' = '), i(1, 'null') }),
      }),
    })
  ),

  -- Method
  s(
    { trig = 'm([a;]?)([uoi])(s?)', regTrig = true },
    fmt('{visibility} function {name}({args}){rtype}{body}', {
      visibility = f(function(_, snip)
        local captures = snip.captures
        local result = php_visibility(captures[2])

        if 'a' == captures[1] then
          result = 'abstract ' .. result
        end

        if 's' == captures[3] then
          result = result .. ' static'
        end

        return result
      end),
      name = i(1, 'method'),
      args = i(2),
      rtype = c(3, {
        sn(nil, { t(': '), i(1, 'void') }),
        t('two'),
        t('three'),
        t(''),
      }),
      body = d(4, function(_, snip)
        if '' ~= snip.captures[1] then
          return sn(nil, t(';'))
        end

        return sn(nil, {
          t({ '', '{' }),
          t({ '', '\t' }),
          f(function()
            return snip.env.TM_SELECTED_TEXT
          end),
          i(1),
          t({ '', '}' }),
        })
      end),
    })
  ),

  -- function
  s(
    { trig = 'f(s?)(;?)', regTrig = true },
    fmt([[
{static}function {name}({args}){rtype} {{
    {body}
}}{semicolon}
    ]], {
      static = f(function(_, snip) return 's' == snip.captures[1] and 'static ' or '' end),
      name = i(1, 'function'),
      args = i(2),
      rtype = c(3, {
        sn(nil, { t(': '), i(1, 'void') }),
        t(''),
      }),
      body = d(4, sn_insert_default_selected),
      semicolon = f(function(_, snip) return ';' == snip.captures[2] and ';' or '' end),
    })
  ),

  -- if
  postfix({ trig = '.if' }, fmt('if ({condition}) {{\n\t{body}\n}}', {
    condition = l(l.POSTFIX_MATCH),
    body = i(1),
  })),
  postfix({ trig = ';if' }, fmt('if ({condition}) {{\n\t{body}\n}}', {
    condition = i(1, 'true'),
    body = l(l.POSTFIX_MATCH .. ';'),
  })),
  s({ trig = 'if' }, fmt('if ({condition}) {{\n\t{body}\n}}', {
    condition = i(1, 'true'),
    body = d(2, sn_insert_default_selected),
  })),

  -- foreach
  postfix({ trig = ';foreach' }, fmt('foreach (${list} as {item}) {{\n\t{body}\n}}', {
    list = i(1, 'list'),
    item = c(2, {
      sn(nil, { t('$'), i(1, 'item') }),
      sn(nil, fmt('${key} => ${value}', { key = i(1, 'key'), value = i(2, 'value') })),
    }),
    body = l(l.POSTFIX_MATCH .. ';'),
  })),
  s({ trig = 'foreach' }, fmt('foreach (${list} as {item}) {{\n\t{body}\n}}', {
    list = i(1, 'list'),
    item = c(2, {
      sn(nil, { t('$'), i(1, 'item') }),
      sn(nil, fmt('${key} => ${value}', { key = i(1, 'key'), value = i(2, 'value') })),
    }),
    body = d(3, sn_insert_default_selected),
  })),

  -- try/catch
  s({ trig = 'tc' }, fmt('try {{\n\t{body}\n}} catch {{\n\t{catch}\n}}', {
    body = d(1, sn_insert_default_selected),
    catch = i(2),
  })),
  s({ trig = 'tf' }, fmt('try {{\n\t{body}\n}} finally {{\n\t{finally}\n}}', {
    body = d(1, sn_insert_default_selected),
    finally = i(2),
  })),
  s({ trig = 'tcf' }, fmt('try {{\n\t{body}\n}} catch {{\n\t{catch}\n}} finally {{\n\t{finally}\n}}', {
    body = d(1, sn_insert_default_selected),
    catch = i(2),
    finally = i(3),
  })),

  -- phpunit
  s({ trig = 'puc' }, fmt([[
{phptag}{namespace}use PHPUnit\Framework\Attributes\CoversClass;
use PHPUnit\Framework\Attributes\Test;
use PHPUnit\Framework\TestCase;

#[CoversClass({covers}::class)]
final class {name} extends TestCase
{{
	{body}
}}
    ]], {
    phptag = d(1, sn_phptag),
    namespace = d(2, sn_namespace),
    covers = f(function (values, _)
      return values[1][1]:gsub('%Test', '')
    end, {3}),
    name = d(3, sn_classname),
    body = d(4, sn_insert_default_selected),
  })),

  s({ trig = 'put' }, fmt([[
#[Test]
public function {test}(): void
{{
	{body}
}}
  ]], {
    test = i(1, 'TestSomething'),
    body = d(2, sn_insert_default_selected),
  })),

  s({ trig = 'pua' }, fmt('$this->assert{assertion}', { assertion = i(1, 'True') })),
  s({ trig = 'puae' }, fmt('$this->assertEquals(${expected}, ${actual});', {
    expected = i(1, 'expected'),
    actual = i(2, 'actual'),
  })),

  s({ trig = 'pue' }, fmt('$this->expectException{choice}', { choice = c(1, {
    t(''),
    t('Object'),
    t('Message'),
    t('MessageMatches'),
    t('MessageCode'),
  }) }))
})
