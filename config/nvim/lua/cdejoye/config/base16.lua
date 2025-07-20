local function customize_lspsaga()
  local hi = require('cdejoye.utils').hi
  local colors = require('base16-colorscheme').colors

  hi('LspSagaFinderSelection', { guifg = colors.base0B, guibg = 'NONE', gui = 'bold' })

  hi('LspFloatWinBorder', 'FloatBorder')
  hi('LspFloatWinTitle', { guifg = colors.base0A, guibg = 'NONE', gui = 'bold' })
  hi('LspFloatWinTruncateLine', 'FloatBorder')
  hi('LspFloatWinNormal', 'Normal')

  hi('LspSagaBorderTitle', { guifg = colors.base09, guibg = 'NONE', gui = 'bold' })

  hi('TargetWord', 'TSError')
  hi('ReferencesCount', 'TSTitle')
  hi('DefinitionCount', 'TSTitle')
  hi('TargetFileName', 'TSComment')
  hi('DefinitionIcon', 'Special')
  hi('ReferencesIcon', 'Special')
  hi('ProviderTruncateLine', 'LspFLoatWinTruncateLine')
  hi('SagaShadow', { guibg = 'bg' })

  hi('LspSagaFinderSelection', { guifg = colors.base0B, guibg = 'NONE', gui = 'bold' })

  hi('DiagnosticTruncateLine', 'LspFLoatWinTruncateLine')

  hi('DefinitionPreviewTitle', 'TSTitle')

  hi('LspSagaDiagnosticBorder', 'LspFloatWinBorder')
  hi('LspSagaDiagnosticHeader', 'LspFloatWinTitle')
  hi('LspSagaDiagnosticTruncateLine', 'LspFloatWinTruncateLine')
  hi('LspDiagnosticsFloatingError', 'LspDiagnosticsDefaultError')
  hi('LspDiagnosticsFloatingWarn', 'LspDiagnosticsDefaultWarning')
  hi('LspDiagnosticsFloatingInfor', 'LspDiagnosticsDefaultInformation')
  hi('LspDiagnosticsFloatingHint', 'LspDiagnosticsDefaultHint')

  hi('LspSagaShTruncateLine', 'LspFloatWinTruncateLine')
  hi('LspSagaDocTruncateLine', 'LspFloatWinTruncateLine')

  hi('LspSagaCodeActionBorder', 'LspFloatWinBorder')
  hi('LspSagaCodeActionTitle', 'LspFloatWinTitle')
  hi('LspSagaCodeActionTruncateLine', 'LspFLoatWinTruncateLine')
  hi('LspSagaCodeActionContent', 'LspFloatWinNormal')

  hi('LspSagaRenameBorder', 'LspFloatWinBorder')
  hi('LspSagaRenamePromptPrefix', { guifg = colors.base0B, guibg = 'NONE' })

  hi('LspSagaHoverBorder', 'LspFloatWinBorder')
  hi('LspSagaSignatureHelpBorder', 'LspFloatWinBorder')
  hi('LspSagaLspFinderBorder', 'LspFloatWinBorder')
  hi('LspSagaAutoPreview', 'LspFloatWinBorder')
  hi('LspSagaDefPreviewBorder', 'LspFloatWinBorder')

  hi('LspSagaLightBulb', 'LspDiagnosticsDefaultHint')
end

-- Tweaks the colors to my taste with a base16 theme
local function customize_base16()
  local colors = require('base16-colorscheme').colors
  local cursorline = colors.base01
  local visual = colors.base02
  local comment = colors.base03
  local blue = colors.base0D

  local hi = require('cdejoye.utils').hi

  hi('FloatBorder', { guifg = blue })

  hi('EndOfBuffer', { guifg = 'bg' }) -- Hide the ~ in the number column
  hi('VertSplit', { guifg = visual }) -- Color of the border between vertival splits

  hi('LineNr', { guifg = comment }) -- Color of the line numbers
  hi('CursorLineNr', { guifg = blue, guibg = 'bg' }) -- Color of the current line number

  hi('Pmenu', { guifg = comment, guibg = cursorline, gui = 'italic' }) -- Completion menu
  hi('PmenuSel', { guifg = 'none', guibg = 'bg', gui = 'bold' }) -- Selected item
  hi('PmenuSbar', 'Pmenu') -- Completion menu scrollbar
  hi('PmenuThumb', { guibg = visual }) -- Completion menu scrollbar's button
  -- Custom ones to use for floating window showing documentation during completion
  hi('PmenuBorder', 'PmenuInvisibleBorder')
  -- Hide the borders by using the same fg and bg but keep the padding having by using borders
  hi('PmenuInvisibleBorder', { guifg = cursorline, guibg = cursorline })

  hi('CmpItemAbbrMatch', { guifg = blue, gui = 'bold' })

  hi('yamlTSField', 'TSKeyword')
end

local function customize_dapui()
  vim.cmd([[
    hi! def link DapUIBreakpointsCurrentLine ModeMsg
    hi! def link DapUIBreakpointsPath TSFunction
    hi! def link DapUIBreakpointsLine DapUIBreakpointsLine
    hi! def link DapUIBreakpointsInfo TSString


    hi! def link DapUIWatchesValue TSString
    hi! def link DapUIWatchesError TSErrorMsg
    hi! def link DapUIWatchesEmpty DapUIWatchesValue

    hi! def link DapUIFloatBorder DapUIDecoration
    hi! def link DapUILineNumber TSFunction
    hi! def link DapUIDecoration TSFunction
    hi! def link DapUIFrameName Normal
    hi! def link DapUIVariable TSVariable
    hi! def link DapUIThread TSString
    hi! def link DapUIStoppedThread TSFunction
    hi! def link DapUIType TSType
    hi! def link DapUISource DapUIType
    hi! def link DapUIScope TSFunction
  ]])
end

local M = {}
function M.setup()
  local augroup = vim.api.nvim_create_augroup('cdejoye_base16_colorscheme', { clear = true })
  vim.api.nvim_create_autocmd('Colorscheme', {
    callback = function()
      customize_base16()
      customize_lspsaga()
      customize_dapui()
    end,
    pattern = 'base16-*',
    group = augroup,
  })
end

return M
