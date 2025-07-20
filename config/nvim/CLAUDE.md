# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration written in Lua using the Lazy plugin manager. The configuration is highly customized for web development, primarily PHP, with comprehensive LSP, testing, and debugging setup.

## Architecture

### Core Structure
- `init.lua` - Main entry point that loads plugins and basic configuration
- `lua/cdejoye/` - Main configuration namespace containing all custom modules
- `lua/cdejoye/lazy.lua` - Plugin definitions using Lazy.nvim
- `lua/cdejoye/plugins/` - Plugins spec loaded by Lazy.nvim
- `lua/cdejoye/config/` - Individual plugin configurations
- `lua/cdejoye/mappings.lua` - Custom key mappings
- `ftplugin/` - Filetype-specific configurations
- `after/plugin/` - Plugin-specific configurations loaded after plugins
- `lsp/` - LSP server configurations (legacy, mostly moved to lua/cdejoye/config/lsp/)

### Key Components

#### Plugin Management
- Uses Lazy.nvim for plugin management
- Plugins are configured with lazy loading where appropriate
- Custom formatters and configs are referenced via helper functions

#### LSP Configuration
- Mason.nvim for LSP server installation
- Custom LSP configurations in `lua/cdejoye/config/lsp/`
- Language-specific setups for PHP (Intelephense, Phpactor), Python (pylsp), Lua, JSON, YAML
- Conform.nvim for formatting with php_cs_fixer, stylua, black, isort
- nvim-lint for linting with phpstan, eslint_d, and custom PHP linters

#### Testing Framework
- vim-test for running tests with custom PHP configurations
- Supports PHPUnit, PHPSpec, and Behat
- Custom test patterns and executable detection
- Key mappings: `<Leader>tf` (file), `<Leader>tn` (nearest), `<Leader>ts` (suite), `<Leader>tl` (last), `<Leader>tv` (visit)

#### Git Integration
- Fugitive for Git operations
- Gitsigns for inline Git information
- Neogit for interactive Git interface
- Diffview for reviewing changes

## Development Commands

### Testing
- `:TestFile` - Run tests for current file
- `:TestNearest` - Run nearest test
- `:TestSuite` - Run full test suite
- `:TestLast` - Run last test
- `:TestVisit` - Visit last test file

### Formatting
- `<Leader>ff` - Format current buffer using conform.nvim
- Uses php_cs_fixer for PHP, stylua for Lua, black/isort for Python

### LSP Commands
- `:Mason` - Manage LSP servers and tools
- `:MasonUpdate` - Update all Mason packages
- Standard LSP commands available through nvim-lspconfig

### Debugging
- Configured with nvim-dap for PHP debugging
- Xdebug support with port 9003
- Path mappings for containerized development

## Configuration Philosophy

### Modular Design
- Each plugin has its own configuration file in `lua/cdejoye/config/`
- Configurations are loaded via a helper function that formats module names
- Custom utilities and mappings are centralized in dedicated modules

### Language Support
- Primary focus on PHP with extensive tooling (Phpactor, php_cs_fixer, phpstan)
- Strong support for web technologies (HTML, CSS, JavaScript)
- Python development with comprehensive linting and formatting
- Lua development optimized for Neovim plugin development

### Key Bindings
- Space as leader key
- Consistent prefixes: `<Leader>t` for testing, `<Leader>s` for search/symbols, `<Leader>c` for code actions
- Claude Code integration with `<Leader>a` prefix for AI assistance

## File Patterns and Conventions

### PHP Testing
- PHPUnit: `*Test.php` files with `test*` methods or `@test` annotations
- PHPSpec: `*Spec.php` files  
- Behat: `*.feature` files
- Custom patterns exclude data providers from test detection

### Project Structure Assumptions
- Uses Composer for PHP dependency management
- Supports containerized development with path mappings
- Coverage reports expected in `coverage/cobertura.xml`
- Local project configuration via `.nvim.lua` files (enabled with `exrc`)
