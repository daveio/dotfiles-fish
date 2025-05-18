# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains Fish shell configuration files managed with `chezmoi`. The configuration is organized across multiple fish scripts that are sourced by the main `config.fish` file. These configuration files set up various environment variables, aliases, abbreviations, and functions for everyday use.

## File Structure and Organization

- `config.fish`: Main entry point that sources other configuration files
- `vars.fish`: Global environment variables
- `abbrs.fish`: Command abbreviations for quick access to common commands
- `aliases.fish`: Command aliases
- `funcs.fish`: Custom functions for various tasks
- `os.fish`: OS-specific configuration (templated based on OS by chezmoi)
- `interactive.fish`: Configuration for interactive shell sessions
- `tools/`: Custom scripts and utilities
  - `sixkcd`: Script to display XKCD comics using Sixel graphics
  - `yank`: Python script to update git repositories in parallel

## Key Utilities

- `yank`: Python script for updating multiple git repositories in parallel with a rich UI
- `yank-all`: Fish function for pulling all git repositories in the current directory
- `sixkcd`: Fish script for displaying XKCD comics using Sixel graphics in iTerm2

## Common Development Tasks

### Adding New Configuration

1. For regular configuration, add it to the appropriate file:

   - Environment variables → `vars.fish`
   - Command abbreviations → `abbrs.fish`
   - Command aliases → `aliases.fish`
   - Functions → `funcs.fish`
   - OS-specific configuration → `os.fish`
   - Interactive shell configuration → `interactive.fish`

2. For sensitive information, add it to `secrets.fish`. This is managed by `chezmoi` to keep it encrypted and not committed to the repository.

### Working with chezmoi

This repository is managed by `chezmoi`. Any changes should be added to chezmoi with:

```fish
chezmoi add <file>   # Add a file to chezmoi
chezmoi add --encrypt <file>  # Add a file to chezmoi and encrypt it
chezmoi apply         # Apply chezmoi changes
```

## Plugins and Integrations

The configuration uses `fisher` for plugin management and includes integrations with:

- `tide`: Prompt customization
- `rose-pine`: Theme
- `starship`: Command prompt
- `mise`: Runtime version manager
- `zoxide`: Directory navigator
- `atuin`: Shell history
- `direnv`: Directory-specific environment variables
- `shadowenv`: Project-specific environments
- Various tools like Docker, Kubernetes, and cloud services

## Common Commands

- `fish_config`: Run the built-in Fish configuration UI
- `fisher update`: Update all Fisher plugins
- `brew bundle dump`: Create a Brewfile with current Homebrew packages
