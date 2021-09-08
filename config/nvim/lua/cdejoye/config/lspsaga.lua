local map = require('cdejoye.utils').map

-- Config
require('lspsaga').init_lsp_saga {
  error_sign = "",
  warn_sign = "",
  infor_sign = "🛈",
  hint_sign = "!",
}

-- Mappings
map('<C-f>', [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>]])
map('<C-b>', [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>]])

-- Theming
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
hi('SagaShadow', { guibg = colors.base00 })

hi('LspSagaFinderSelection', { guifg = colors.base0B, guibg = 'NONE', gui = 'bold' })

hi('DiagnosticTruncateLine', 'LspFLoatWinTruncateLine')
hi('DiagnosticError', 'LspDiagnosticsDefaultError')
hi('DiagnosticWarning', 'LspDiagnosticsDefaultWarning')
hi('DiagnosticInformation', 'LspDiagnosticsDefaultInformation')
hi('DiagnosticHint', 'LspDiagnosticsDefaultHint')

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

hi('LspSagaRenameBorder', { guifg = colors.base0A, guibg = 'NONE' })
hi('LspSagaRenamePromptPrefix', { guifg = colors.base0D, guibg = 'NONE' })

hi('LspSagaHoverBorder', 'LspFloatWinBorder')
hi('LspSagaSignatureHelpBorder', 'LspFloatWinBorder')
hi('LspSagaLspFinderBorder', 'LspFloatWinBorder')
hi('LspSagaAutoPreview', 'LspFloatWinBorder')
hi('LspSagaDefPreviewBorder', 'LspFloatWinBorder')

hi('LspSagaLightBulb', 'LspDiagnosticsDefaultHint')
