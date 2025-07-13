# Native Snippets for Neovim

A comprehensive, TDD-driven native snippet system for Neovim that integrates seamlessly with nvim-cmp, providing an alternative to LuaSnip with built-in Neovim snippet support.

## Overview

This project implements a modular snippet system using Neovim's native `vim.snippet.expand()` functionality. It provides a clean, maintainable architecture with comprehensive test coverage and follows strict TDD principles.

## Features

- **Native Integration**: Uses Neovim's built-in snippet support via `vim.snippet.expand()`
- **nvim-cmp Integration**: Seamless completion source integration
- **Modular Architecture**: Each snippet is self-contained for easy maintenance
- **TDD Excellence**: 28+ tests with 100% coverage across unit and integration tests
- **Language Support**: Currently supports PHP with easy extensibility

## Architecture

```
lua/native-snippets/
├── init.lua                    # nvim-cmp source entry point
├── completion_provider.lua     # Central orchestrator for all snippets
├── snippets/php/              # Language-specific snippet modules
│   ├── date.lua               # Dynamic date generation
│   ├── construct.lua          # PHP constructor
│   ├── function.lua           # Function template
│   ├── method.lua             # Method with visibility
│   └── class.lua              # Class template
└── tests/                     # Comprehensive test suite
    ├── minimal_init.lua       # Test environment setup
    └── spec/                  # Test specifications
        ├── unit/              # Fast unit tests
        │   ├── completion_provider_spec.lua # Orchestrator tests
        │   ├── cmp_source_spec.lua         # Source interface tests
        │   └── snippets/php/               # Individual snippet tests
        │       ├── date_spec.lua
        │       ├── construct_spec.lua
        │       ├── function_spec.lua
        │       ├── method_spec.lua
        │       └── class_spec.lua
        └── integration/       # Full integration tests
            └── integration_spec.lua     # nvim-cmp integration tests
```

## Available Snippets

### PHP Snippets

- **`n_date`** - Inserts current date (YYYY-MM-DD format)
- **`n_construct`** - PHP constructor with parameter and body placeholders
- **`n_function`** - Function with name, parameter, and body placeholders
- **`n_method`** - Method with visibility (default: public), name, parameter, and body placeholders
- **`n_class`** - Class with name and body placeholders

All snippets use proper snippet format for indentation and provide interactive placeholders for customization.

## Development

### Testing

The project uses a comprehensive TDD approach with plenary.nvim for testing:

```bash
# Run all tests (unit + integration)
nvim --headless -c 'PlenaryBustedDirectory lua/native-snippets/tests/spec { init = "lua/native-snippets/tests/minimal_init.lua" }'

# Run only fast unit tests (for development)
nvim --headless -c 'PlenaryBustedDirectory lua/native-snippets/tests/spec/unit { init = "lua/native-snippets/tests/minimal_init.lua" }'

# Run only integration tests (for CI/verification)
nvim --headless -c 'PlenaryBustedDirectory lua/native-snippets/tests/spec/integration { init = "lua/native-snippets/tests/minimal_init.lua" }'
```

### TDD Methodology

The project follows strict **RED-GREEN-REFACTOR-FORMAT-LINT** cycles:

1. **RED**: Write failing test
2. **GREEN**: Implement minimal code to pass
3. **REFACTOR**: Improve code structure
4. **FORMAT**: Apply code formatting (`conform.nvim`)
5. **LINT**: Check diagnostics and fix issues
6. **VERIFY**: Run full test suite

### Adding New Snippets

1. Create snippet module in `snippets/{language}/`
2. Write comprehensive test spec in `tests/spec/snippets/{language}/`
3. Add to completion provider
4. Follow TDD methodology throughout

### Code Quality

- **Formatting**: Uses `stylua` via `conform.nvim`
- **Linting**: LSP diagnostics and `luacheck`
- **Testing**: 100% test coverage requirement
- **Documentation**: Comprehensive function annotations

## Integration

The system integrates with nvim-cmp as a completion source:

```lua
-- In your cmp setup
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
}, {
  { name = 'native_snippets' },  -- Add this line
  -- ... other sources
})

-- Register the source
cmp.register_source('native_snippets', require('native-snippets'))
```

## Benefits Over LuaSnip

- **Simpler Setup**: Uses built-in Neovim functionality
- **Better Performance**: Native implementation
- **Easier Maintenance**: Modular architecture with clear separation
- **Test-Driven**: Comprehensive test coverage ensures reliability
- **Future-Proof**: Built on Neovim's native snippet support

## Contributing

1. Follow TDD methodology
2. Maintain 100% test coverage
3. Use proper code formatting
4. Add comprehensive documentation
5. Test with both unit and integration test suites

## Test Philosophy

This project follows a **"Tests as Specifications"** philosophy where tests serve as living documentation and clear behavioral specifications rather than implementation verification.

### Core Principles

#### 1. **Tests Should Be Crystal Clear Specifications**
Tests must be immediately understandable without "heavy thinking" or analysis. When reading a test, it should be obvious what the system should produce.

**Before (Implementation-focused):**
```lua
it('should contain PHP method structure', function()
  assert.is_true(string.find(item.insertText, 'function') ~= nil)
  assert.is_true(string.find(item.insertText, '{') ~= nil)
  assert.is_true(string.find(item.insertText, '}') ~= nil)
end)
```

**After (Specification-focused):**
```lua
it('should provide valid n_method snippet', function()
  local item = method_snippet.create()
  assert.snippet('n_method', [[
    ${1:public} function ${2:name}($3): ${4:void}
    {
      $0
    }
  ]], item)
end)
```

#### 2. **Visual Expectations Over Technical Checks**
Use multi-line strings to show exactly what the output should look like. The test should visually represent the expected result.

#### 3. **Comprehensive Single Assertions**
Prefer one assertion that validates everything (structure + content) over multiple fragmented assertions checking pieces.

#### 4. **Failure Feedback That Guides Debugging**
When tests fail, the output should immediately show exactly what's wrong with git-style diff visualization.

### Custom Assertion System

The project uses domain-specific assertions that follow luassert conventions:

```lua
-- Combined structure + content validation
assert.snippet(expected_label, expected_text, item)

-- Legacy assertions (for backward compatibility)
assert.snippet.structure(expected_label, item)  -- LSP structure only
assert.snippet.text(expected_text, item)        -- Content only
```

### Git-Style Diff Feedback

When content validation fails, tests show precise character-level differences:

```
- ${1:public} function ${2:name}($3) ${4:void}    # Expected (red background)
+ ${1:public} function ${2:name}($3): ${4:void}   # Actual (green background)
```

The diff highlights:
- **Red background**: What was expected
- **Green background**: What was actually received  
- **Bright highlighting**: Specific character differences
- **Complete line coloring**: Full context with proper backgrounds

### When to Apply This Approach

**Use specification-focused tests for:**
- ✅ **System behavior validation**: When testing what the system produces
- ✅ **Complex output structures**: Snippets, templates, formatted text
- ✅ **User-facing features**: Tests should be readable as documentation
- ✅ **Regression prevention**: Need precise validation of exact output

**Use traditional implementation tests for:**
- ❌ **Simple boolean conditions**: `assert.is_true()` for basic checks
- ❌ **Performance testing**: Implementation details matter for performance
- ❌ **Internal algorithm verification**: When you need to test the HOW

### Test Transformation Pattern

When transforming existing tests:

1. **Identify the specification**: What should the system produce?
2. **Create visual expectations**: Use multi-line strings showing exact structure
3. **Build comprehensive assertions**: Validate everything in one clear assertion
4. **Ensure meaningful failure feedback**: Git-style diffs for immediate debugging
5. **Reduce cognitive load**: One clear test instead of multiple fragmented ones

### Multi-line String Handling

The assertion system automatically normalizes multi-line test strings:
- Removes common leading indentation for readability
- Converts spaces to tabs for snippet format compatibility
- Preserves empty lines and structure

```lua
-- This test string is automatically normalized
assert.snippet.text([[
  ${1:public} function ${2:name}($3): ${4:void}
  {
    $0
  }
]], item)
```

### Benefits of This Approach

1. **Living Documentation**: Tests serve as examples of system behavior
2. **Immediate Understanding**: No reverse-engineering required to understand expectations
3. **Better Debugging**: Precise visual feedback on failures
4. **Reduced Maintenance**: Fewer, more comprehensive tests
5. **Clear Specifications**: Tests answer "what should this do?" not "how does this work?"

This philosophy transforms tests from verification code into living specifications that guide both development and understanding.

## Testing Requirements

All changes must pass the complete test suite. The project maintains strict quality standards:

- All tests must pass
- No new lint/diagnostic issues
- Proper code formatting
- Comprehensive test coverage for new features