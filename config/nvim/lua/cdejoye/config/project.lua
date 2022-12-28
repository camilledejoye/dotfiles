local map = require('cdejoye.utils').map

require('project_nvim').setup {
}

if pcall(require, 'telescope') then
  require('telescope').load_extension('projects');
end

map('<Leader>sp', [[<cmd>Telescope projects<CR>]])
