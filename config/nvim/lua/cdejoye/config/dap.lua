local dap = require('dap') -- Must be before overriding the signs
local dapui = require('dapui')
local g = vim.g

require('telescope').load_extension('dap')

dapui.setup {
  icons = { expanded = '', collapsed = '' },
  mappings = {
    expand = { 'za', '<CR>', '<2-LeftMouse>' },
  },
  sidebar = { position = 'right', size = 80 },
}

-- Not sure it's working...
g.dap_virtual_text = true

-- Theme
local sign = vim.fn.sign_define

sign('DapBreakpoint', { text = '', texthl = 'ErrorMsg', linehl = '', numhl = '' })
sign('DapLogPoint', { text = '', texthl = 'Question', linehl = '', numhl = '' })
sign('DapStopped', { text = ' ', texthl = 'String', linehl = '', numhl = '' })
sign('DapBreakpointRejected', { text = '', texthl = 'ErrorMsg', linehl = '', numhl = '' })

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

-- Mappings
local map = require('cdejoye.utils').map

map('<F5>', [[
  <cmd>lua require('dap').continue()<CR>
  <cmd>echohl ModeMsg | echom 'Debugger is listening...' | echohl None<CR>
]])
map('<F8>', [[
  <cmd>lua require('dap').close()<CR>
  <cmd>lua require('dapui').close()<CR>
  <cmd>echohl ModeMsg | echom 'Debugger closed' | echohl None<CR>
]])
map('<F09>', [[<cmd>lua require('dap').step_over()<CR>]])
map('<F10>', [[<cmd>lua require('dap').step_into()<CR>]])
map('<F11>', [[<cmd>lua require('dap').step_out()<CR>]])
map('<Leader>db', [[<cmd>lua require('dap').toggle_breakpoint()<CR>]])
map('<Leader>dr', [[<cmd>lua require('dap').repl_open()<CR>]])
map('<Leader>de', [[<cmd>lua require('dapui').eval()<CR>]], 'nv')

-- Adapters
local php_adapter_dir = vim.env.VSCODE_PHP_DEBUG_HOME or '/home/cdejoye/work/vscode-php-debug'

dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { php_adapter_dir .. '/out/phpDebug.js' },
}
dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Lister for Xdebug',
    port = 9003,
    pathMappings = {
      ['/var/www/html'] = '${workspaceFolder}',
    }
  }
}
