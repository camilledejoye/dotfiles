-- https://gist.github.com/camilledejoye/a6e49a0168cd4d302936af7a8647870e
local M = {}

local has_telescope, _ = pcall(require, 'telescope')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local conf = require('telescope.config').values

local function filter(list, callback)
  local filtered = {}
  for _, value in pairs(list) do
    if callback(value) then
      table.insert(filtered, value)
    end
  end

  return filtered
end

local function readables(files)
  return filter(files, function (file)
    return 1 == vim.fn.filereadable(file)
  end)
end

local function projectionist_alternates()
  local cwd = vim.fn.getcwd()
  local raw = vim.call('projectionist#query', 'alternate')
  local alternates = {}

  local function add_paths(paths)
    if 'string' == type(paths) then
      table.insert(alternates, paths)
    else
      for _, path in pairs(paths) do
        table.insert(alternates, path)
      end
    end
  end

  for _, projections in pairs(raw) do
    local root, paths = projections[1], projections[2]
    vim.validate('paths', paths, { 'table', 'string' })
    if cwd == root then
      add_paths(paths)
    end
  end

  return alternates
end

local function open_with_projectionist_cmd()
  if 2 ~= vim.fn.exists(':AV') then
    vim.notify('No alternates file found.', vim.log.levels.INFO)
    return
  end

  vim.notify('Fallback to projectionist :AV command', vim.log.levels.WARN)
  vim.cmd('AV')
end

local function open_in_existing_tab_window(filename)
  local bufname = vim.fn.bufname(filename)
  local winnr_in_tab = nil
  if '' ~= bufname then
    local bufnr = vim.fn.bufnr(bufname)
    for _, winnr in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if bufnr == vim.api.nvim_win_get_buf(winnr) then
        winnr_in_tab = winnr
        break
      end
    end
  end

  local is_already_open = nil ~= winnr_in_tab
  if is_already_open then
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.api.nvim_set_current_win(winnr_in_tab)
  end

  return is_already_open
end

local function open_in_new_window(filename)
    vim.cmd('vsp '..filename)
end

local function open(filename)
  if not open_in_existing_tab_window(filename) then
    open_in_new_window(filename)
  end
end

local function show_in_picker(alternates, opts)
  opts = opts or {}

  pickers.new(opts, {
    prompt_tile = 'Alternate files',
    finder = finders.new_table(alternates),
    sorter = conf.generic_sorter(opts),
    previewer = conf.file_previewer(opts),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        open(selection[1])
      end)
      return true
    end,
  }):find()
end

M.open_alternates = function (opts)
  opts = opts or {}
  local alternates = projectionist_alternates()

  if false ~= opts.only_existing then
    local readables = readables(alternates)
    if 0 < #readables then
      alternates = readables
    end
  end

  local count = #alternates
  if 0 == count then
    open_with_projectionist_cmd() -- In case I messed up something
  elseif 1 == count then
    open(alternates[1])
  else
    if has_telescope then
      show_in_picker(alternates, opts)
    else
      open_with_projectionist_cmd()
    end
  end
end

return M
