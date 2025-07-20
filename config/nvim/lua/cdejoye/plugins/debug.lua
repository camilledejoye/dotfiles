--- @module lazy
--- @type LazySpec
return {
  -- https://github.com/mfussenegger/nvim-dap
  -- PHP adapter installation: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#PHP
  'mfussenegger/nvim-dap',
  dependencies = {
    {
      'rcarriga/nvim-dap-ui',
      dependencies = 'nvim-neotest/nvim-nio',
      opts = {
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
      },
    },
    { 'theHamsta/nvim-dap-virtual-text', config = true },
  },
  config = function()
    -- Signs
    local sign = vim.fn.sign_define

    sign('DapBreakpoint', { text = '', texthl = 'ErrorMsg', linehl = '', numhl = '' })
    sign('DapLogPoint', { text = '', texthl = 'Question', linehl = '', numhl = '' })
    sign('DapStopped', { text = ' ', texthl = 'String', linehl = '', numhl = '' })
    sign('DapBreakpointRejected', { text = '', texthl = 'ErrorMsg', linehl = '', numhl = '' })

    -- Listeners
    local dap = require('dap') -- Must be before overriding the signs
    local dapui = require('dapui')

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end

    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end

    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end
  end,
  keys = {
    {
      '<Leader>dc',
      function()
        require('dap').continue()
      end,
      desc = 'Start/Resume a debugging session',
    },
    {
      '<Leader>ds',
      function()
        require('dap').terminate()
        require('dapui').close()
      end,
      desc = 'Close a debugging session',
    },
    {
      '<Leader>dd',
      function()
        require('dap').step_over()
      end,
      desc = 'Step over the current instruction',
    },
    {
      '<Leader>di',
      function()
        require('dap').step_into()
      end,
      desc = 'Step into the current instruction',
    },
    {
      '<Leader>do',
      function()
        require('dap').step_out()
      end,
      desc = 'Step out to the parent instruction',
    },
    {
      '<Leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Toggle breakpoint',
    },
    {
      '<Leader>dB',
      function()
        vim.ui.input({ prompt = 'Breakpoint condition: ' }, function(input)
          require('dap').set_breakpoint(input)
        end)
      end,
      desc = 'Toggle breakpoint with condition',
    },
    {
      '<Leader>dr',
      function()
        require('dap').repl.open()
      end,
      desc = 'Open a REPL',
    },
    {
      '<Leader>de',
      function()
        require('dapui').eval()
      end,
      mode = { 'n', 'v' },
      desc = 'Evaluate the current word or selection and show the results in a floating window',
    },
  },
}
