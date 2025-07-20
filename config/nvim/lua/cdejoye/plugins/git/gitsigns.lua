--- @module lazy
--- @type LazySpec
return { -- GitSigns
  'lewis6991/gitsigns.nvim',
  event = 'VeryLazy',
  opts = {
    watch_gitdir = {
      interval = 250,
      follow_files = true,
    },

    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local bmap = function(mode, lsh, rsh, opts)
        require('cdejoye.utils').bmap(bufnr, lsh, rsh, mode, opts)
      end

      -- Navigation
      bmap('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gs.nav_hunk('next')
        end
      end)

      bmap('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gs.nav_hunk('prev')
        end
      end)

      -- Actions
      bmap('n', '<leader>sh', gs.stage_hunk)
      bmap('v', '<leader>sh', function()
        gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end)
      bmap('n', '<leader>uh', gs.reset_hunk)
      bmap('v', '<leader>uh', function()
        gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end)
      bmap('n', '<leader>Rh', gs.reset_buffer)
      bmap('n', '<leader>ph', gs.preview_hunk)
      bmap('n', '<leader>bh', function()
        gs.blame_line({ full = true })
      end)
      bmap('n', '<leader>Sh', gs.stage_buffer)
      bmap('n', '<leader>Uh', gs.reset_buffer_index)

      bmap('n', '<leader>hu', gs.undo_stage_hunk)
      bmap('n', '<leader>Uh', gs.reset_buffer_index)
      bmap('n', '<leader>tb', gs.toggle_current_line_blame)
      bmap('n', '<leader>hd', gs.diffthis)
      bmap('n', '<leader>hD', function()
        gs.diffthis('~')
      end)
      bmap('n', '<leader>td', gs.toggle_deleted)

      -- Text object
      bmap('ox', 'ih', gs.select_hunk)
    end,
  },
}
