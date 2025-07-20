--- @module lazy
--- @type LazySpec
return {
  'jake-stewart/multicursor.nvim',
  config = function()
    local mc = require('multicursor-nvim')
    mc.setup()

    -- Mappings defined in a keymap layer only apply when there are
    -- multiple cursors. This lets you have overlapping mappings.
    mc.addKeymapLayer(function(layerSet)
      -- Select a different cursor as the main one.
      layerSet({ 'n', 'x' }, '<left>', mc.prevCursor)
      layerSet({ 'n', 'x' }, '<right>', mc.nextCursor)

      -- Select and jump to the next match
      layerSet({ 'v', 'x' }, '<C-p>', function()
        mc.matchAddCursor(-1)
      end)
      layerSet({ 'v', 'x' }, '<C-s>', function()
        mc.matchSkipCursor(1)
      end)
      -- Delete the main cursor.
      layerSet({ 'v', 'x' }, '<C-x>', mc.deleteCursor)

      -- Enable and clear cursors using escape.
      layerSet('n', '<esc>', function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end)
    end)
  end,
  keys = {
    {
      '<C-n>',
      function()
        vim.cmd.normal('viw')
        require('multicursor-nvim').matchAddCursor(1)
      end,
      mode = 'n',
      desc = 'Start multi-cursor for the word under the cursor',
    },
    {
      '<C-n>',
      function()
        require('multicursor-nvim').matchAddCursor(1)
      end,
      mode = 'x',
      desc = 'Add current selection to the list of cursors and jump to the next match',
    },
  },
}
