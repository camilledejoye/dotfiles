--- @module lazy
--- @type lazy.LazySpec
return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  build = ':call mkdp#util#install()',
  ft = 'markdown',
  keys = {
    {
      '<C-p>',
      '<Plug>MarkdownPreview',
      desc = 'Open markdown preview in browser',
      ft = 'markdown',
    },
  },
}
