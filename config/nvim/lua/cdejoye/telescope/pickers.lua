local builtin = require('telescope.builtin')

local pickers = {}

function pickers.find_files(options) -- Find with git and fallback if not a git repository
  options = options or {}

  if not pcall(builtin.git_files, options) then
    builtin.find_files(options)
  end
end

function pickers.find_files_in_plugins(options)
  return builtin.find_files(vim.tbl_extend('force', {
    prompt_title = 'Plugins',
    --- disable because for `data` the return value is `string`
    ---@diagnostic disable-next-line: param-type-mismatch
    cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy'),
  }, options or {}))
end

function pickers.find_files_in_config(options)
  return builtin.find_files(vim.tbl_extend('force', {
    prompt_title = 'Config files',
    cwd = vim.env.XDG_CONFIG_HOME or '~/.config',
    no_ignore = true,
    hidden = true,
    follow = true,
  }, options or {}))
end

function pickers.grep_string(args, bang)
  args = args or {}
  -- Always include hidden files and follow symlinks
  local vimgrep_arguments = vim
    .iter({ require('telescope.config').values.vimgrep_arguments, {
      '--hidden',
      '-L',
    } })
    :flatten()
    :totable()
  local options = {
    search_dirs = {}, -- remove the ./ in front of the results if no search_dirs are provided
    use_regex = true, -- Will only be used if options.search is defined
  }

  -- If there is more than one argument and the last argument is a file or directory
  if 1 < #args and '' ~= vim.fn.glob(args[#args]) then
    options.search_dirs = { table.remove(args) }
  end

  if 0 < #args then
    -- Use all remaining arguments as a search pattern
    options.search = table.concat(args, ' ')
  end

  if bang then
    options = vim.tbl_extend('force', {
      vimgrep_arguments = vim.iter({ vimgrep_arguments, { '--no-ignore' } }):flatten():totable(),
    }, options)
  end

  return builtin.grep_string(options)
end

function pickers.live_grep(options)
  local vimgrep_arguments = require('telescope.config').values.vimgrep_arguments

  return builtin.live_grep(vim.tbl_extend('force', {
    vimgrep_arguments = vim.iter({ vimgrep_arguments, { '--hidden', '--no-ignore', '-L' } }):flatten():totable(),
  }, options or {}))
end

return pickers
