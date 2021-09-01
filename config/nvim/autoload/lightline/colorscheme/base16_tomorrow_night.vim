" g:base16_gui00 #1d1f21
" g:base16_gui01 #282a2e
" g:base16_gui02 #373b41
" g:base16_gui03 #969896
" g:base16_gui04 #b4b7b4
" g:base16_gui05 #c5c8c6
" g:base16_gui08 #cc6666
" g:base16_gui09 #de935f
" g:base16_gui0A #f0c674
" g:base16_gui0B #b5bd68
" g:base16_gui0C #8abeb7
" g:base16_gui0D #81a2be
" g:base16_gui0E #b294bb
" g:base16_gui0F #a3685a

lua << EOF
for name, hex_color in pairs(require('colors.tomorrow-night')) do
  gui_name = 'base16_gui' .. name:sub(5)

  vim.g[gui_name] = hex_color
end
EOF
let g:base16_cterm01 = 10
let g:base16_cterm02 = 11
let g:base16_cterm03 = 08
let g:base16_cterm04 = 12
let g:base16_cterm05 = 07
let g:base16_cterm08 = 01
let g:base16_cterm0A = 03
let g:base16_cterm0D = 04

let s:base16_gui00 = '#'.g:base16_gui00
let s:base16_gui01 = '#'.g:base16_gui01
let s:base16_gui02 = '#'.g:base16_gui02
let s:base16_gui03 = '#'.g:base16_gui03
let s:base16_gui04 = '#'.g:base16_gui04
let s:base16_gui05 = '#'.g:base16_gui05
let s:base16_gui08 = '#'.g:base16_gui08
let s:base16_gui09 = '#'.g:base16_gui09
let s:base16_gui0A = '#'.g:base16_gui0A
let s:base16_gui0B = '#'.g:base16_gui0B
let s:base16_gui0C = '#'.g:base16_gui0C
let s:base16_gui0D = '#'.g:base16_gui0D
let s:base16_gui0E = '#'.g:base16_gui0E
let s:base16_gui0F = '#'.g:base16_gui0F

let s:palette = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:palette.normal.left = [
  \ [s:base16_gui01, s:base16_gui0D, g:base16_cterm01, g:base16_cterm0D],
  \ [s:base16_gui05, s:base16_gui02, g:base16_cterm05, g:base16_cterm02],
\ ]
let s:palette.inactive.left =  [
  \ [s:base16_gui03, s:base16_gui01, g:base16_cterm03, g:base16_cterm01],
  \ [s:base16_gui03, s:base16_gui01, g:base16_cterm03, g:base16_cterm01],
\ ]
let s:palette.insert.left = [copy(s:palette.normal.left[0]), s:palette.normal.left[1]]
let s:palette.replace.left = [copy(s:palette.normal.left[0]), s:palette.normal.left[1]]
let s:palette.visual.left = [copy(s:palette.normal.left[0]), s:palette.normal.left[1]]
" Update the background color for each mode
let s:palette.insert.left[0][1] = s:base16_gui0B
let s:palette.replace.left[0][1] = s:base16_gui09
let s:palette.visual.left[0][1] = s:base16_gui0E

let s:palette.normal.middle = [
  \ [s:base16_gui04, s:base16_gui01, g:base16_cterm04, g:base16_cterm01],
\ ]
let s:palette.inactive.middle = [copy(s:palette.inactive.left[0])]

" The right side should be the same as the left side
for mode in ['normal', 'inactive', 'insert', 'replace', 'visual']
  let s:palette[mode].right = s:palette[mode].left
endfor

let s:palette.normal.error = [
  \ [s:base16_gui08, s:base16_gui01, g:base16_cterm08, g:base16_cterm01],
\ ]
let s:palette.normal.warning = [
  \ [s:base16_gui0A, s:base16_gui01, g:base16_cterm0A, g:base16_cterm01],
\ ]

let s:palette.tabline.left = [s:palette.normal.left[1]]
let s:palette.tabline.middle = s:palette.normal.middle
let s:palette.tabline.right = s:palette.tabline.left
let s:palette.tabline.tabsel = [s:palette.normal.left[0]]

let g:lightline#colorscheme#base16_tomorrow_night#palette = s:palette
" let g:lightline#colorscheme#base16_tomorrow_night#palette = lightline#colorscheme#fill(s:palette)
