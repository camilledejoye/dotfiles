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
        ├── integration_spec.lua        # nvim-cmp integration tests
        ├── completion_provider_spec.lua # Orchestrator tests
        ├── cmp_source_spec.lua         # Source interface tests
        └── snippets/php/               # Individual snippet tests
            ├── date_spec.lua
            ├── construct_spec.lua
            ├── function_spec.lua
            ├── method_spec.lua
            └── class_spec.lua
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
# Run all tests
nvim --headless -c 'PlenaryBustedDirectory lua/native-snippets/tests/spec { init = "lua/native-snippets/tests/minimal_init.lua" }'
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

## Testing Requirements

All changes must pass the complete test suite. The project maintains strict quality standards:

- All tests must pass
- No new lint/diagnostic issues
- Proper code formatting
- Comprehensive test coverage for new features