let g:my_vim_dir = fnamemodify(resolve(expand('<sfile>')), ':p:h')

" If running vim, update the runtimepath to be able to use the plugins
if !has('nvim')
  execute 'set runtimepath^=' . g:my_vim_dir
  execute 'set runtimepath+=' . g:my_vim_dir . '/after'
  let &packpath = &runtimepath
endif

" To add a personal templates directory to the runtimepath
execute 'set runtimepath+=' . g:my_vim_dir . '/templates'

let mapleader = ','

filetype plugin indent on
syntax on

set path+=**
set noautochdir
" Ignore third party's directories
set wildignore+=*/.git/*,*/vendor/*,*/node_modules/*,*/var/*,*/web/build/*

set hidden
set number
set relativenumber
set cursorline
set laststatus=2
set modelines=5
set ts=4 sts=4 sw=4 expandtab
set listchars=tab:»\ ,eol:¬
set incsearch
set nojoinspaces
set display+=lastline
set splitright
set scrolloff=3
set diffopt+=vertical
set wildmenu

if has('termguicolors')
  set termguicolors
endif

if has('nvim')
  set inccommand=nosplit
endif

" Autoload all config files
for s:config_file in glob(g:my_vim_dir . '/config/*.vim', v:false, v:true)
  execute 'source ' s:config_file
endfor

" vim: ts=2 sw=2 et fdm=marker
