local M = {}

---Copy of the wrap util from nvim-lint, in order to provide the bufnr in addition to the diagnostic
---@param linter lint.Linter|fun():lint.Linter
---@param map fun(diagnostic: vim.Diagnostic, bufnr: integer): vim.Diagnostic
---@return lint.Linter|fun():lint.Linter
function M.wrap(linter, map)
  local function _wrap(l, m)
    local result = vim.deepcopy(l)
    result.parser = function(output, bufnr)
      local diagnostics = l.parser(output, bufnr)
      return vim.tbl_map(function(diagnostic)
        return m(diagnostic, bufnr)
      end, diagnostics)
    end
    return result
  end
  if type(linter) == "function" then
    return function()
      return _wrap(linter(), map)
    end
  else
    return _wrap(linter, map)
  end
end

return M
