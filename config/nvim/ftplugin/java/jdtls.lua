local jdtls_loaded, jdtls = pcall(require, 'jdtls')
if not jdtls_loaded then
  return
end

local joinpath = vim.fs.joinpath
local function get_config_dir()
  if 1 == vim.fn.has('linux') then
    return 'config_linux'
  end

  if 1 == vim.fn.has('mac') then
    return 'config_mac'
  end

  return 'config_win'
end

local home = os.getenv('HOME')
local workspace_path = joinpath(home, '.local', 'share', 'nvim', 'jdtls-workspace')
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local capabilities = require('cdejoye.config.lsp').capabilities
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
local java_bin = vim.env.JAVA_HOME and joinpath(vim.env.JAVA_HOME, 'bin', 'java') or 'java'
local mason_path = joinpath('', vim.fn.stdpath('data'), '/mason')
local jdtls_path = joinpath(mason_path, 'packages', 'jdtls')

local function get_bundles()
  local bundles = {}

  local java_test_plugins = vim.fn.globpath(
    joinpath(mason_path, 'packages', 'java-test', 'extension', 'server'),
    '*.jar',
    false,
    true
  )
  if 0 < #java_test_plugins then
    vim.list_extend(bundles, java_test_plugins)
  end

  local java_debug_plugins = vim.fn.globpath(
    joinpath(mason_path, 'packages', 'java-debug-adapter', 'extension', 'server'),
    'com.microsoft.java.debug.plugin-*.jar',
    false,
    true
  )
  if 0 < #java_debug_plugins then
    vim.list_extend(bundles, java_debug_plugins)
  end

  return bundles
end

local function get_jar()
  local opts = vim.fn.globpath(
    joinpath(jdtls_path, 'plugins'),
    'org.eclipse.equinox.launcher_*.jar',
    false,
    true
  )

  if 0 == #opts then
    error('Impossible to find the JAR file for jdtls', vim.log.levels.ERROR)
  end

  return opts[1]
end

---- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    java_bin,
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    -- To adapt if I used lombok one day
    -- '-javaagent:' .. home .. '/.local/share/nvim/mason/packages/jdtls/lombok.jar',

    '-jar', get_jar(),
    '-configuration', joinpath(jdtls_path, get_config_dir()),

    -- See `data directory configuration` section in the README
    '-data', joinpath(workspace_path, project_name)
  },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  --
  -- vim.fs.root requires Neovim 0.10.
  -- If you're using an earlier version, use: require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
  root_dir = vim.fs.root(0, {'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'}),

  capabilities = capabilities,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
      },
      maven = {
        downloadSources = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = 'all', -- literals, all, none
        },
      },
      format = {
        enabled = true,
      },
    },
    signatureHelp = { enabled = true },
    extendedClientCapabilities = extendedClientCapabilities,
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = get_bundles()
  },
  on_attach = function (client, bufnr)
    local _, _ = pcall(vim.lsp.codelens.refresh)
    -- require("jdtls").setup_dap({ hotcodereplace = "auto" })
    require('cdejoye.config.lsp').on_attach(client, bufnr)
    -- local status_ok, jdtls_dap = pcall(require, "jdtls.dap")
    -- if status_ok then
    --   jdtls_dap.setup_dap_main_class_configs()
    -- end

    local function bmap(...) require('cdejoye.utils').bmap(bufnr, ...) end

    bmap('<leader>coi', [[<cmd>lua require('jdtls').organize_imports()<CR>]])
    bmap('<leader>cv', [[<cmd>lua require('jdtls').extract_variable()<CR>]])
    bmap('<leader>cv', [[<esc><cmd>lua require('jdtls').extract_variable(true)<CR>]], 'v')
    bmap('<leader>cc', [[<cmd>lua require('jdtls').extract_constant()<CR>]])
    bmap('<leader>cc', [[<esc><cmd>lua require('jdtls').extract_constant(true)<CR>]], 'v')
    bmap('<leader>cm', [[<cmd>lua require('jdtls').extract_method()<CR>]])
    bmap('<leader>cm', [[<esc><cmd>lua require('jdtls').extract_method(true)<CR>]], 'v')
  end
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)

-- refresh codelens on save
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.java" },
  callback = function()
    local _, _ = pcall(vim.lsp.codelens.refresh)
  end,
})
