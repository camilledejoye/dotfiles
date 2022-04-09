local telescope = require('telescope.builtin')
local jump_types = {
  edit = 'edit',
  split = 'split',
  vsplit = 'vsplit',
  tabedit = 'tab',
}

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
