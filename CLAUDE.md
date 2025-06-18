# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Kixvim is a NixVim configuration that provides a comprehensive Neovim setup using Nix flakes. The configuration is modular and designed for easy testing and modification without rebuilding NixOS.

## Common Development Commands

### Core Commands
- `nix run .` - Launch Neovim with the configuration (primary testing command)
- `nix flake check .` - Verify configuration integrity and run checks
- `nix fmt` - Format Nix code using Alejandra formatter
- `nix develop` - Enter development shell with pre-commit hooks

### Development Workflow
- Configuration files are in `./config/` directory
- When adding new config files, add them to `config/default.nix`
- Use `nix run .` to test changes immediately
- Pre-commit hooks automatically run code quality checks

## Architecture and Structure

### Core Configuration Pattern
- **Entry Point**: `config/default.nix` imports all configuration modules
- **Plugin Organization**: Plugins are grouped in `config/plugins/` by category:
  - `lsp/` - Language server configurations
  - `kickstart/` - Kickstart.nvim plugin ports
  - `custom/` - Custom plugin configurations
- **Language Support**: Language-specific configs in `config/language/`

### Flake Structure
- Uses `flake-parts` for modular organization
- Custom plugin sources defined as flake inputs (snacks-nvim, trouble-nvim)
- Exports both NixOS and Home Manager modules
- Pre-commit hooks integrated via `git-hooks-nix`

### Key Configuration Files
- `config/keys.nix` - Key mappings (leader key is Space)
- `config/auto.nix` - Auto-commands
- `config/snacks.nix` - Snacks plugin configuration
- `flake/checks.nix` - CI/CD configuration

## Plugin System

### Adding Plugins
1. Add plugin configuration file in appropriate `config/plugins/` subdirectory
2. Import the file in `config/default.nix`
3. For external plugins, add to flake inputs if needed

### Built-in Features
- Claude Code integration accessible via `<leader>cC`
- Comprehensive LSP support with nvim-lsp-config
- File navigation with Telescope and Neo-tree
- Git integration with Gitsigns and LazyGit
- Testing support with Neotest and Overseer

## Installation Patterns

The configuration supports three installation methods:
1. **Standalone**: `nix run github:klowdo/kixvim`
2. **NixOS Module**: Import `nixosModules.nixvim` and enable `programs.nixvim`
3. **Home Manager**: Import `homeModules.nixvim` and enable `programs.nixvim`

## Code Quality

- Alejandra formatter for Nix code
- Pre-commit hooks for deadnix, shellcheck, and file validation
- Automated flake updates via Renovate
- CI/CD pipeline runs formatting and integrity checks
