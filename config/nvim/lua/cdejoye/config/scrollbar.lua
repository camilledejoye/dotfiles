local function trim(text)
  return text:match('^%s*(.-)%s*$')
end

local function lsp_sign(type)
  local sign = vim.fn.sign_getdefined('LspDiagnosticsSign'..type)[1] or nil

  if not sign then
    return nil
  end

  return trim(sign.text)
end

local error_sign = lsp_sign('Error') or ''
local warn_sign = lsp_sign('Warning') or ''
local info_sign = lsp_sign('Information') or ''
local hint_sign = lsp_sign('Hint') or ''

local git_signs = {}
if pcall(require, 'gitsigns') then
  -- Needed for the highlight group to be created in time
  require('gitsigns.highlight').setup_highlights()

  -- Retrive the signs defined in gitstigns to share the same configuration
  git_signs = vim.tbl_map(function (sign)
    return sign.text
  end, require('gitsigns.config').config.signs)
end

require('scrollbar').setup({
  marks = {
    GitAdd = {
      text = git_signs.add or '+',
    },
    GitChange = {
      text = git_signs.change or '~',
    },
    GitDelete = {
      text = git_signs.delete or '_',
    },
    Error = {
      text = { error_sign, error_sign },
    },
    Warn = {
      text = { warn_sign, warn_sign },
    },
    Info = {
      text = { info_sign, info_sign },
    },
    Hint = {
      text = { hint_sign, hint_sign },
    },
  },
  handlers = {
    cursor = false,
    gitsigns = true,
  },
})
