local fzf = require('fzf-lua')
local fzf_actions = require('fzf-lua.actions')

local telescope = require('telescope.builtin')
local jump_types = {
  edit = 'edit',
  split = 'split',
  vsplit = 'vsplit',
  tabedit = 'tab',
}

local validate = vim.validate
local valid_edit_cmds = { 'edit', 'split', 'vsplit', 'tabedit' }
local actions_map = {
  edit = fzf_actions.file_edit,
  split = fzf_actions.file_split,
  vsplit = fzf_actions.file_vsplit,
  tabedit = fzf_actions.file_tabedit,
}

local function implode(list, sep)
  local tmp = {}
  for k, _ in pairs(list) do
    table.insert(tmp, k)
  end

  return table.concat(tmp, sep)
end

local function is_valid_edit_cmd(edit_cmd)
  local is_valid = nil == edit_cmd or actions_map[edit_cmd]
  local message = 'Valid commands: ' .. implode(vim.tbl_keys(valid_edit_cmds), ', ')

  return is_valid, message
end

local function make_options(edit_cmd, options)
  local default_options = {
    -- Make it synchronous to avoid opening the window when there is only one result
    async_or_timeout = 2000,
    jump_to_single_result = true,
  }

  if edit_cmd then
    default_options.jump_to_single_result_action = actions_map[edit_cmd]
  end

  return vim.tbl_extend('force', default_options, options or {})
end

local function fzf_handler(handler, edit_cmd, options)
  validate {
    edit_cmd = { edit_cmd, is_valid_edit_cmd, 'Invalid edit command' }
  }

  options = make_options(edit_cmd, options)

  fzf[handler](options)
end

local fzf_buf = {}

function fzf_buf.definition(edit_cmd)
  return fzf_handler('lsp_definitions', edit_cmd)
end

function fzf_buf.declaration(edit_cmd)
  return fzf_handler('lsp_declarations', edit_cmd)
end

function fzf_buf.type_definition(edit_cmd)
  return fzf_handler('lsp_typedefs', edit_cmd)
end

function fzf_buf.implementation(edit_cmd)
  return fzf_handler('lsp_implementations', edit_cmd)
end

function fzf_buf.references(edit_cmd)
  -- For references it might take a while so I force it to be async
  -- There is almost no chance there will be only one result anyway
  return fzf_handler('lsp_references', edit_cmd, { async = true })
end

local telescope_buf = {}

function telescope_buf.definition(edit_cmd)
  return telescope.lsp_definitions({ jump_type = jump_types[edit_cmd] or nil })
end

function telescope_buf.declaration(edit_cmd)
  return telescope.lsp_declarations({ jump_type = jump_types[edit_cmd] or nil })
end

function telescope_buf.type_definition(edit_cmd)
  return telescope.lsp_type_definitions({ jump_type = jump_types[edit_cmd] or nil })
end

function telescope_buf.implementation(edit_cmd)
  return telescope.lsp_implementations({ jump_type = jump_types[edit_cmd] or nil })
end

function telescope_buf.references(edit_cmd)
  return telescope.lsp_references({ jump_type = jump_types[edit_cmd] or nil })
end

return telescope_buf
