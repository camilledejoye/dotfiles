local dap = require('dap') -- Must be before overriding the signs
local dapui = require('dapui')

if pcall(require, 'telescope') then
  require('telescope').load_extension('dap');
end

dapui.setup {
  icons = { expanded = '', collapsed = '' },
  mappings = {
    expand = { 'za', '<CR>', '<2-LeftMouse>' },
  },
  layouts = {
    {
      -- Elements can be strings or table with id and size keys.
      elements = {
        { id = 'scopes', size = 0.60 },
        { id = 'breakpoints', size = 0.20 },
        { id = 'stacks', size = 0.20 },
      },
      size = 0.30,
      position = 'right',
    },
    {
      elements = {
        'watches',
        -- 'repl',
        -- 'console',
      },
      size = 0.20,
      position = 'bottom',
    },
  },
  controls = {
    -- Requires Neovim nightly (or 0.8 when released)
    enabled = true,
    -- Display controls in this element
    element = 'watches',
    icons = {
      pause = '',
      play = '',
      step_into = '',
      step_over = '',
      step_out = '',
      step_back = '',
      run_last = '',
      terminate = '',
    },
  },
}

require('nvim-dap-virtual-text').setup({})

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

-- Listeners
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Mappings
local map = require('cdejoye.utils').map

map('<Leader>dc', [[<cmd>lua require('dap').continue()<CR>]])
map('<Leader>ds', [[
  <cmd>lua require('dap').terminate()<CR>
  <cmd>lua require('dapui').close()<CR>
]])
map('<Leader>dd', [[<cmd>lua require('dap').step_over()<CR>]])
map('<Leader>di', [[<cmd>lua require('dap').step_into()<CR>]])
map('<Leader>do', [[<cmd>lua require('dap').step_out()<CR>]])
map('<Leader>db', [[<cmd>lua require('dap').toggle_breakpoint()<CR>]])
map('<Leader>dB', function()
  vim.ui.input({ prompt = 'Breakpoint condition: ' }, function(input)
    require('dap').set_breakpoint(input)
  end)
end)
map('<Leader>dr', [[<cmd>lua require('dap').repl.open()<CR>]])
map('<Leader>de', [[<cmd>lua require('dapui').eval()<CR>]], 'nv')
