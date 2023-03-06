-- https://github.com/glepnir/lspsaga.nvim
local map = require('cdejoye.utils').map

-- Config
require('lspsaga').setup({
  code_action_lightbulb = {
    sign = false,
  },
  symbol_in_winbar = {
    enable = true,
    show_file = false,
  },
})

-- Theming
local colorscheme = vim.g.colors_name
local is_base16 = 'string' == type(colorscheme) and 'base16' == colorscheme:sub(1, 6)

if is_base16 then
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
