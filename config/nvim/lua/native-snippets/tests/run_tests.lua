local function run_all_tests()
  print('🧪 Running Native Snippets Tests...')
  require('plenary.busted').run('lua/native-snippets/tests/spec/completion_provider_spec.lua')
  require('plenary.busted').run('lua/native-snippets/tests/spec/cmp_source_spec.lua')
end

return { run = run_all_tests }

