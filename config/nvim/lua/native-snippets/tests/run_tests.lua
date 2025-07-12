-- Test runner for native snippets with tiered execution
local function run_unit_tests()
  print('🧪 Running Unit Tests...')

  -- Run completion provider tests
  print('\n📦 Testing Completion Provider...')
  require('plenary.busted').run('lua/native-snippets/tests/spec/completion_provider_spec.lua')

  -- Run cmp source tests
  print('\n🔗 Testing CMP Source...')
  require('plenary.busted').run('lua/native-snippets/tests/spec/cmp_source_spec.lua')

  -- Run individual snippet tests
  print('\n📝 Testing Individual Snippets...')
  print('  📅 PHP Date Snippet...')
  require('plenary.busted').run('lua/native-snippets/tests/spec/snippets/php/date_spec.lua')
  print('  🏗️  PHP Constructor Snippet...')
  require('plenary.busted').run('lua/native-snippets/tests/spec/snippets/php/construct_spec.lua')
  print('  ⚡ PHP Function Snippet...')
  require('plenary.busted').run('lua/native-snippets/tests/spec/snippets/php/function_spec.lua')
  print('  🔧 PHP Method Snippet...')
  require('plenary.busted').run('lua/native-snippets/tests/spec/snippets/php/method_spec.lua')

  print('\n✅ Unit tests complete!')
end

local function run_integration_tests()
  print('🔧 Running Integration Tests...')

  -- Run integration tests
  print('\n🌐 Testing nvim-cmp Integration...')
  require('plenary.busted').run('lua/native-snippets/tests/spec/integration_spec.lua')

  print('\n✅ Integration tests complete!')
end

local function run_all_tests()
  print('🚀 Running All Native Snippets Tests...')

  run_unit_tests()
  run_integration_tests()

  print('\n🎉 All tests complete!')
end

return {
  unit = run_unit_tests,
  integration = run_integration_tests,
  all = run_all_tests,
  run = run_all_tests, -- backward compatibility
}
