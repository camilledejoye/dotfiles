-- Telescope: https://github.com/nvim-telescope/telescope.nvim

local map = require('cdejoye.utils').map

require('packer').use {
  'nvim-telescope/telescope.nvim',
  requires = {
    'nvim-lua/plenary.nvim',
    'kyazdani42/nvim-web-devicons',
  },
  config = require('telescope').setup {
    defaults = {
      prompt_prefix = '❯ ',
      selection_caret = '❯ ',
      -- file_sorter =  require'telescope.sorters'.get_fzy_sorter,
      -- generic_sorter =  require'telescope.sorters'.get_fzy_sorter,
    },
    pickers = {
      buffers = {
        sort_lastused = true,
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
      grep_string = { theme = 'ivy' },
      spell_suggest = { theme = 'cursor' }
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = 'smart_case',
      },
      -- TODO rewrite them to work for my taste with possibility to easily add --no-ignore
      -- and/or --hidden
      fzf_writer = {
        use_highlighter = true,
      },
    },
  },
}

require('packer').use {
  "nvim-telescope/telescope-fzf-native.nvim",
  run = "make",
}
require('telescope').load_extension('fzf')

require('packer').use('nvim-telescope/telescope-fzf-writer.nvim')
require('telescope').load_extension('fzf_writer')

map('<Leader>sf', [[<cmd>lua require('telescope.builtin').git_files()<CR>]])
map('<Leader>sF', [[<cmd>lua require('telescope.builtin').find_files({ no_ignore = true })<CR>]])
map('<Leader>sb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]])
map('<Leader>sc', [[<cmd>lua require('telescope.builtin').git_commits()<CR>]])

map('<Leader>rg', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]])
map('<Leader>Rg', [[<cmd>lua require('cdejoye/telescope').rg({ no_ignore = true })<CR>]])

vim.cmd([[command! -complete=dir -nargs=* Rg lua require('telescope.builtin').live_grep({ search_dirs = { unpack({<f-args>}) } })]])
vim.cmd([[command! H lua require('telescope.builtin').help_tags()]])
map('z=', [[<cmd>lua require('telescope.builtin').spell_suggest()<CR>]])

-- Highlights
vim.cmd('hi! def link TelescopeBorder Directory')
vim.cmd('hi! def link TelescopePromptPrefix String')
vim.cmd('hi! def link TelescopeSelectionCaret String')

-- Custom pickers/writers
local M = {}
local Job = require('plenary.job')

local conf = require('telescope.config').values
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local sorters = require('telescope.sorters')

local flatten = vim.tbl_flatten

local escape_chars = function(string)
  return string.gsub(string, "[%(|%)|\\|%[|%]|%-|%{%}|%?|%+|%*|%^|%$]", {
    ["\\"] = "\\\\",
    ["-"] = "\\-",
    ["("] = "\\(",
    [")"] = "\\)",
    ["["] = "\\[",
    ["]"] = "\\]",
    ["{"] = "\\{",
    ["}"] = "\\}",
    ["?"] = "\\?",
    ["+"] = "\\+",
    ["*"] = "\\*",
    ["^"] = "\\^",
    ["$"] = "\\$",
  })
end

-- Special keys:
--  opts.search -- the string to search.
--  opts.search_dirs -- list of directory to search in
--  opts.use_regex -- special characters won't be escaped
function M.rg(opts)
  -- TODO: This should probably check your visual selection as well, if you've got one

  local vimgrep_arguments = conf.vimgrep_arguments
  local search_dirs = opts.search_dirs
  local word = opts.search or vim.fn.expand "<cword>"
  local search = opts.use_regex and word or escape_chars(word)
  local word_match = opts.word_match
  local no_ignore = opts.no_ignore or false
  opts.entry_maker = opts.entry_maker or make_entry.gen_from_vimgrep(opts)

  if no_ignore then
    table.insert(vimgrep_arguments, '--no-ignore')
  end

  local additional_args = {}
  if opts.additional_args ~= nil and type(opts.additional_args) == "function" then
    additional_args = opts.additional_args(opts)
  end

  local args = vim.tbl_flatten {
    vimgrep_arguments,
    additional_args,
    word_match,
    search,
  }

  if search_dirs then
    for _, path in ipairs(search_dirs) do
      table.insert(args, vim.fn.expand(path))
    end
  -- To have filenames not starting with ./
  -- else
  --   table.insert(args, ".")
  end

  pickers.new(opts, {
    prompt_title = "Find Word",
    finder = finders.new_oneshot_job(args, opts),
    previewer = conf.grep_previewer(opts),
    sorter = conf.generic_sorter(opts),
  }):find()
end

-- From https://github.com/nvim-telescope/telescope-fzf-writer.nvim
-- Trigger an error with devicon if called first, but not if called after another finder
-- which also uses devicon...
function M.rg2(opts)
  opts = opts or {}

  local fzf_separator = opts.fzf_separator or "|"

  local live_grepper = finders._new {
    fn_command = function(_, prompt)
      if #prompt < 2 then
        return nil
      end

      local rg_prompt, fzf_prompt
      if string.find(prompt, fzf_separator, 1, true) then
        rg_prompt  = string.sub(prompt, 1, string.find(prompt, fzf_separator, 1, true) - 1)
        fzf_prompt = string.sub(prompt, string.find(prompt, fzf_separator, 1, true) + #fzf_separator, #prompt)
      else
        rg_prompt = prompt
        fzf_prompt = ""
      end

      local rg_args = flatten { conf.vimgrep_arguments, rg_prompt }
      table.remove(rg_args, 1)

      return {
        writer = Job:new {
          command = 'rg',
          args = rg_args,
        },

        command = 'fzf',
        args = {'--filter', fzf_prompt},
      }
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    maximum_results = opts.max_results,
    cwd = opts.cwd or vim.loop.cwd(),
  }

  pickers.new(opts, {
      prompt_title = 'Fzf Writer: Grep',
      finder = live_grepper,
      previewer = conf.grep_previewer(opts),
      sorter = true and sorters.highlighter_only(opts) or nil,
    }):find()
end

return M
