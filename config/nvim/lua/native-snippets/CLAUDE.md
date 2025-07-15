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

#### 2. **One Clear Assertion Per Test (Golden Rule)**
Each test should have **ONE comprehensive assertion** that validates the complete expected behavior. If you have multiple assertions, you're likely testing implementation details rather than user-facing specifications. (Note: There are valid exceptions, but this rule catches most specification vs implementation issues.)

**Before (Fragmented Implementation Testing):**
```lua
it('should contain PHP method structure', function()
  assert.is_true(string.find(item.insertText, 'function') ~= nil)
  assert.is_true(string.find(item.insertText, '{') ~= nil)
  assert.is_true(string.find(item.insertText, '}') ~= nil)
  assert.equals('n_method', item.label)
  assert.equals(vim.lsp.protocol.CompletionItemKind.Snippet, item.kind)
end)
```

**After (Single Clear Specification):**
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

#### 3. **Visual Expectations Over Technical Checks**
Use multi-line strings to show exactly what the output should look like. The test should visually represent the expected result.

#### 4. **Comprehensive Single Assertions**
Create domain-specific assertions that validate everything (structure + content) in one clear statement.

#### 5. **Failure Feedback That Guides Debugging**
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
2. **Apply the one assertion rule**: If you have multiple assertions, combine them into one comprehensive assertion
3. **Create visual expectations**: Use multi-line strings showing exact structure
4. **Build comprehensive assertions**: Validate everything in one clear assertion
5. **Ensure meaningful failure feedback**: Git-style diffs for immediate debugging
6. **Verify the pattern**: Does your test look like other transformed tests?

**Red Flag**: If your test has more than one assertion, ask yourself:
- Am I testing implementation details instead of user-facing behavior?
- Can I create a domain-specific assertion that validates everything at once?
- Does this test immediately show what the user receives?

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

## Future Enhancement Roadmap

These are tracked improvements to consider implementing:

### LSP Advanced Features
- [ ] **Choice snippets for visibility**: Implement LSP `Choice` for function/method visibility selection  
  - Reference: [LSP Choice specification](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#choice)
  - Use case: Interactive visibility selection (public/protected/private) instead of separate snippets
  
- [ ] **Variable transformation for class names**: Use LSP variable transforms for smart class naming  
  - Reference: [LSP Variable Transforms](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#variable-transforms)
  - Use case: Auto-capitalize class names, convert filenames to class names, etc.

### Snippet Enhancement
- [ ] **Documentation for snippets**: Add `CompletionItem.documentation` with usage examples
  - Provide helpful descriptions and examples for each snippet
  - Improve discoverability and user experience
  
- [ ] **Insert text mode support**: Investigate `CompletionItem.insertTextMode` usage
  - Reference: [LSP InsertTextMode](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#insertTextMode)
  - Potential replacement/addition to current `InsertTextFormat`
  
- [ ] **Text edit for existing content**: Explore `CompletionItem.textEdit` for smart replacements
  - Reference: [LSP TextEdit](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textEdit)
  - Use case: Postfix snippets, smart content modification based on context
  - May not apply to standard snippets, investigate postfix snippet potential

### Implementation Notes
- All enhancements should follow existing TDD methodology
- Maintain backward compatibility with current API
- Add comprehensive test coverage for new LSP features
- Document new capabilities in this file

## Regex-Style Method Snippets Implementation Plan

**STATUS: IN PROGRESS** - Implementing incremental regex-like method snippet mappings to reproduce convenient shorthand patterns.

### Completed Steps ✅

#### Step 1: Basic Visibility Variants (COMPLETED)
- ✅ **n_mu** - public method (`n_m[u]` where u = universal/public)
- ✅ **n_mo** - protected method (`n_m[o]` where o = open to children/protected)  
- ✅ **n_mi** - private method (`n_m[i]` where i = internal/private)
- ✅ All tests passing with comprehensive coverage
- ✅ Integration with completion provider
- ✅ Committed at: `14d8e5e`

### Next Steps (Remaining Work)

#### Step 2: Static Method Variants (CURRENT TASK)
**📍 START HERE** - Add static variants of the visibility methods:
- [ ] **n_mus** - public static method (`n_m[u]s`)
- [ ] **n_mos** - protected static method (`n_m[o]s`) 
- [ ] **n_mis** - private static method (`n_m[i]s`)

Pattern: `n_m[uoi]s?` where optional `s` suffix adds `static` keyword.

#### Step 3: Abstract Method Variants
- [ ] **n_mau** - abstract public method (`n_ma[u]`)
- [ ] **n_mao** - abstract protected method (`n_ma[o]`)
- [ ] **n_mai** - abstract private method (`n_ma[i]`)

Pattern: `n_ma[uoi]` where `a` prefix adds `abstract` keyword.

#### Step 4: Validate Abstract Static Combinations
- [ ] **n_masu** - abstract static public method 
- [ ] **n_maso** - abstract static protected method
- [ ] **n_masi** - abstract static private method

Pattern: `n_mas[uoi]` combining both `abstract` and `static` keywords.

#### Step 5: Interface Method Variants (No Body, Semicolon)
- [ ] **n_m;u** - interface public method (`n_m[;][u]`)
- [ ] **n_m;o** - interface protected method (`n_m[;][o]`)
- [ ] **n_m;i** - interface private method (`n_m[;][i]`)

Pattern: `n_m[a;][uoi]` where `;` indicates interface methods (no body, ends with semicolon).

### Implementation Guidelines

**For each step, follow TDD methodology:**
1. **RED**: Write failing tests for new snippet variants
2. **GREEN**: Implement minimal code to pass tests
3. **REFACTOR**: Clean up implementation if needed
4. **FORMAT**: Apply stylua formatting
5. **LINT**: Check with luacheck
6. **VERIFY**: Run full test suite
7. **COMMIT**: Commit completed step before proceeding

**Key considerations:**
- Update `completion_provider.lua` to include new snippets
- Update test count assertions in provider and cmp source tests
- Maintain consistent naming patterns and documentation
- Each variant should generate proper PHP syntax for its context
- Interface methods should not have method bodies, only declarations ending with `;`

**Current Status:** Step 1 completed successfully. Ready to begin Step 2 (static method variants) when development resumes.