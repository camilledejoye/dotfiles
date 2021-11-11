command! CloseAllFloatingWindows lua
  \ for _, win in ipairs(vim.api.nvim_list_wins()) do
  \   local config = vim.api.nvim_win_get_config(win)
  \   if config.relative ~= "" then
  \     vim.api.nvim_win_close(win, true)
  \     print('Closing window', win)
  \   end
  \ end
