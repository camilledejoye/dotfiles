require('neogit').setup({
  integrations = {
    telescope = true,
    diffview = true,
  },
  -- override/add mappings
  mappings = {
    -- modify status buffer mappings
    status = {
      ['za'] = 'Toggle',
      ['zM'] = 'Depth1',
      ['zR'] = 'Depth4',
      ['1'] = false,
      ['2'] = false,
      ['3'] = false,
      ['4'] = false,
    },
  },
})

require('cdejoye.utils').map('<Leader>gs', '<cmd>Neogit<CR>', 'n')

-- Theming
local function customize_theme()
  local chevron = require('cdejoye.icons').chevron
  local hi = require('cdejoye.utils').hi
  local function sign_define(sections)
    for section, opts in pairs(sections) do
      vim.fn.sign_define('NeogitOpen:'..section, opts[1] or {} )
      vim.fn.sign_define('NeogitClosed:'..section, opts[2] or {} )
    end
  end

  hi('NeogitBranch', '@include')
  hi('NeogitRemote', '@define')
  hi('NeogitObjectId', 'Identifier') -- commit hash
  hi('NeogitDiffAdd', 'DiffAdd') -- Colors for hunk diffs
  hi('NeogitDiffDelete', 'DiffDelete') -- Colors for hunk diffs
  hi('NeogitStash', 'NeogitObjectId') -- stash ref: HEAD@{N}
  hi('NeogitUnpulledFrom', 'NeogitRemote') -- Probably the ref to the remote
  hi('NeogitUnmergedInto', 'NeogitRemote') -- Probably the ref to the remove
  hi('NeogitRebaseDone', 'NeogitDiffAdd')
  hi('NeogitRebasing', '@function.call')

  -- Sections
  hi('NeogitUntrackedfiles', '@text.emphasis')
  hi('NeogitUnstagedchanged', '@text.danger')
  hi('NeogitStagedchanges', 'NeogitDiffAdd')
  hi('NeogitStashes', '@comment')
  hi('NeogitUnpulledchanges', 'NeogitRemote') -- Things in remote branch to pull
  hi('NeogitUnmergedchanges', 'NeogitBranch') -- Things in local branch to push
  hi('NeogitRecentcommits', '@text.note')

  -- Didn't saw it shown so I won't change it right now
  -- hi('NeogitFold', '@comment')

  sign_define({
    section = {
      { text = chevron.down, texthl = '@comment' },
      { text = chevron.right, texthl = '@comment' },
    },
    item = {
      { text = chevron.down, texthl = '@comment' },
      { text = chevron.right, texthl = '@comment' },
    },
    hunk = { { linehl = 'Special' }, { linehl = '@comment' } },
  })
end

local neogit_group = vim.api.nvim_create_augroup('cdejoye_neogit_theme', { clear = true })
vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
  pattern = 'base16-*',
  group = neogit_group,
  callback = customize_theme,
})
