-- Telescope: https://github.com/nvim-telescope/telescope.nvim
local telescope = require('telescope')
local actions = require('telescope.actions')
local map = require('cdejoye.utils').map
local hi = require('cdejoye.utils').hi
local cmd = vim.cmd

-- Setup
telescope.setup {
  defaults = {
    prompt_prefix = '❯ ',
    selection_caret = '❯ ',
    sorting_strategy = 'ascending',
    dynamic_preview_title = true,

    mappings = {
        i = { ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist },
        n = { ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist },
    },
  },

  pickers = {
    buffers = {
      ignore_current_buffer = true,
      selection_strategy = 'closest',
      -- theme = 'ivy',
      mappings = {
        n = {
          ['dd'] = 'delete_buffer',
        },
        i = {
          ['<C-d>'] = 'delete_buffer',
        },
      },
    },

    grep_string = { layout_strategy = 'vertical' },
    spell_suggest = {
      theme = 'cursor',
      mappings = {
        i = {
          ['<Esc>'] = actions.close,
        },
      },
    },
    lsp_code_actions = {
      theme = 'cursor',
      mappings = {
        i = {
          ['<Esc>'] = actions.close,
        },
      },
    },
  },

  extensions = {
    fzf = {
      fuzzy = true,
      -- To be able to use fzf syntax: !, ', etc
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
  },
}
telescope.load_extension('fzf')

-- Mappings
map('<Leader>sf', [[<cmd>lua require('cdejoye.config.telescope').find_files()<CR>]])
map('<Leader>sF', [[<cmd>lua require('telescope.builtin').find_files({ no_ignore = true, hidden = true })<CR>]])
map('<Leader>sb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
map('<Leader>sc', [[<cmd>lua require('telescope.builtin').git_commits()<CR>]])
map('<Leader>rg', [[<cmd>Rg<CR>]])
map('<Leader>Rg', [[<cmd>Rg!<CR>]])
map('<Leader>H', [[<cmd>H<CR>]])
map('z=', [[<cmd>lua require('telescope.builtin').spell_suggest()<CR>]])

-- Commands
-- Example unpacking command arguments
-- cmd([[command! -complete=dir -nargs=* Rg lua require('telescope.builtin').live_grep({ search_dirs = { unpack({<f-args>}) } })]])
cmd([[command! -bang -complete=dir -nargs=* Rg lua require('cdejoye.config.telescope').grep_string({ <f-args> }, '!' == '<bang>')]])
cmd([[command! H lua require('telescope.builtin').help_tags()]])
cmd([[command! Tplugins lua require('cdejoye.config.telescope').find_files_in_plugins()]])
cmd([[command! Tconfig lua require('cdejoye.config.telescope').find_files_in_config()]])

-- Highlights
hi('TelescopeBorder', 'FloatBorder')
hi('TelescopePromptPrefix', 'TSString')
hi('TelescopeSelectionCaret', 'TSString')

-- Custom pickers
local builtin = require('telescope.builtin')

local M = {}

function M.find_files(options) -- Find with git and fallback if not a git repository
  options = options or {}

  if not pcall(builtin.git_files, options) then
    builtin.find_files(options)
  end
end

function M.find_files_in_plugins(options)
  return builtin.find_files(vim.tbl_extend('force', {
    prompt_title = 'Plugins',
    cwd = vim.fn.stdpath('data') .. '/site/pack/packer',
  }, options or {}))
end

function M.find_files_in_config(options)
  return builtin.find_files(vim.tbl_extend('force', {
    prompt_title = 'Config files',
    cwd = vim.env.XDG_CONFIG_HOME or '~/.config',
    no_ignore = true,
    hidden = true,
    follow = true,
  }, options or {}))
end

function M.grep_string(args, bang)
  args = args or {}
  -- Always include hidden files and follow symlinks
  local vimgrep_arguments = vim.tbl_flatten { require('telescope.config').values.vimgrep_arguments, {
    '--hidden',
    '-L',
  } }
  local options = {
    search_dirs = {}, -- remove the ./ in front of the results if no search_dirs are provided
    use_regex = true, -- Will only be used if options.search is defined
  }

  if 1 == #args then
    options.search = args[1]
  elseif 1 < #args then
    options.search = args[1]
    options.search_dirs = { args[2] }
  end

  if bang then
    options = vim.tbl_extend('force', {
      vimgrep_arguments = vim.tbl_flatten { vimgrep_arguments, { '--no-ignore' } }
    }, options)
  end

  return builtin.grep_string(options)
end

function M.live_grep(options)
  local vimgrep_arguments = require('telescope.config').values.vimgrep_arguments

  return builtin.live_grep(vim.tbl_extend('force', {
    vimgrep_arguments = vim.tbl_flatten { vimgrep_arguments, { '--hidden', '--no-ignore', '-L' } }
  }, options or {}))
end

return M
