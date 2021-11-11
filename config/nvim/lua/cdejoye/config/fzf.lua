local actions = require('fzf-lua.actions')

require('fzf-lua').setup {
  winopts = {
    preview = {
      wrap = 'wrap',
      -- veritcal = 'down:45%',
      horizontal = 'right:40%',
    },
  },
  keymap = {
    builtin = {
      page_up = '<C-u>',
      page_down = '<C-d>',
    },
    fzf = {
      'f2:toggle-preview',
      'f3:toggle-preview-wrap',
      'ctrl-f:page-down',
      'ctrl-b:page-up',
      -- 'ctrl-d:half-page-down',
      -- 'ctrl-u:half-page-up',
      'shift-down:preview-page-down',
      'shift-up:preview-page-up',
      'ctrl-d:preview-page-down',
      'ctrl-u:preview-page-up',
      'ctrl-a:toggle-all',
      'ctrl-l:clear-query',
    },
  },

  -- Providers
  lsp = {
    icons = {
      -- Only accept terminal colors, lucky me I have the same colorscheme for both
      ['Error']       = { icon = '', color = 'red' },
      ['Warning']     = { icon = '', color = 'yellow' },
      ['Information'] = { icon = '🛈', color = 'blue' },
      ['Hint']        = { icon = '', color = 'magenta' },
    },
  },
}

-- For standard fzf & fzf.vim
-- -- The directory of fzf must also be in the runtimepath
-- if not vim.fn.filereadable('/usr/share/vim/vimfiles/plugin/fzf.vim') then
--   -- Otherwise use the version in the dotfiles
--   vim.opt.runtimepath:append(vim.env.DOTFILES .. '/fzf')
-- end

-- vim.g.fzf_action = {
--   -- ['ctrl-q'] = build_quickfix,
--   ['ctrl-t'] = 'tab split',
--   ['ctrl-x'] = 'split',
--   ['ctrl-v'] = 'vsplit',
-- }

-- -- To open FZF in a new window at the bottom of the screen
-- vim.g.fzf_layout = { down = '30%' }

-- -- To open FZF in a floating window
-- vim.g.fzf_layout = { window = {
--   highlight = 'Comment',
--   width = 0.99,
--   height = 0.95,
--   border = 'sharp',
-- } }

-- vim.cmd([[
-- " Helpers {{{

-- " Add a default action to add entries to the quickfix
-- function! s:buildQuickfixList(lines) abort
--   function! s:buildQuickfixItem(line) abort
--     let l:matches = matchlist(a:line, '\v^(.{-})%(:(\d+))?%(:(\d+))?%(\s+(.+))?$')

--     return {
--       \ 'filename': l:matches[1],
--       \ 'lnum': l:matches[2],
--       \ 'col': l:matches[3],
--       \ 'text': l:matches[4],
--       \ }
--   endfunction

--   call setqflist(map(copy(a:lines), { k,v -> s:buildQuickfixItem(v) }))
--   copen
--   cc
-- endfunction

-- " }}}

-- " Config {{{

-- " Hide the status line when not using a floating window
-- if has('nvim') && type(get(get(g:, 'fzf_layout', {}), 'window', '')) != type({})
--   autocmd! FileType fzf
--   autocmd  FileType fzf set laststatus=0 noshowmode noruler
--     \ | autocmd BufLeave <buffer> set laststatus=2 showmode ruler
-- endif

-- " }}}

-- " Mappings {{{

-- " nmap <Leader>sf :GFiles<CR>
-- " nmap <Leader>sF :Files<CR>
-- " nmap <Leader>sb :Buffers<CR>
-- " nmap <Leader>sc :Commits<CR>

-- " nnoremap <silent> <Leader>rg :Rg \b<C-R>=expand('<cword>')<CR>\b<CR>

-- " }}}

-- " Commands {{{

-- " From fzf plugins

-- " To be able to pass options
-- command! -bang -nargs=* -complete=dir RRg
--   \ call fzf#vim#grep(
--   \   'rg --column --line-number --no-heading --color=always --smart-case '. <q-args>, 1,
--   \   <bang>0 ? fzf#vim#with_preview('up:60%')
--   \           : fzf#vim#with_preview('right:50%:hidden', '?'),
--   \   <bang>0)

-- " command! -bang H call fzf#vim#helptags(<bang>0)

-- " }}}
-- " ]])
