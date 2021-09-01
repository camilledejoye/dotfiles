local validate = vim.validate
local buf = {}
local valid_edit_cmds = {
  e = true,
  edit = true,
  sp = true,
  split = true,
  vsp = true,
  vsplit = true,
  tabe = true,
  tabedit = true,
}

local function implode(list, sep)
  local tmp = {}
  for k, _ in pairs(list) do
    table.insert(tmp, k)
  end

  return table.concat(tmp, sep)
end

local function is_valid_edit_cmd(edit_cmd)
  local is_valid = true == (valid_edit_cmds[edit_cmd] or nil)
  local message = 'Valid commands: ' .. implode(valid_edit_cmds, ', ')

  return is_valid, message
end

local function request(method, edit_cmd)
  local params = vim.lsp.util.make_position_params()
  local handler = buf.goto_handler(edit_cmd)

  return vim.lsp.buf_request(0, method, params, handler)
end

function buf.goto_handler(edit_cmd)
  local util = vim.lsp.util
  local log = require("vim.lsp.log")
  local api = vim.api

  local handler = function(_, method, result)
    if result == nil or vim.tbl_isempty(result) then
      local _ = log.info() and log.info(method, "No location found")
      return nil
    end

    if edit_cmd then
      vim.cmd(edit_cmd)
    end

    if vim.tbl_islist(result) then
      util.jump_to_location(result[1])

      if #result > 1 then
        util.set_qflist(util.locations_to_items(result))
        api.nvim_command("copen")
        api.nvim_command("wincmd p")
      end
    else
      util.jump_to_location(result)
    end
  end

  return handler
end

function buf.definition(edit_cmd)
  validate {
    edit_cmd = { edit_cmd, is_valid_edit_cmd, 'Invalid edit command' }
  }

  return request('textDocument/definition', edit_cmd or 'edit')
end

function buf.declaration(edit_cmd)
  validate {
    edit_cmd = { edit_cmd, is_valid_edit_cmd, 'Invalid edit command' }
  }

  return request('textDocument/declaration', edit_cmd or 'edit')
end

function buf.type_definition(edit_cmd)
  validate {
    edit_cmd = { edit_cmd, is_valid_edit_cmd, 'Invalid edit command' }
  }

  return request('textDocument/typeDefinition', edit_cmd or 'edit')
end

function buf.implementation(edit_cmd)
  validate {
    edit_cmd = { edit_cmd, is_valid_edit_cmd, 'Invalid edit command' }
  }

  return request('textDocument/implementation', edit_cmd or 'edit')
end

return buf
