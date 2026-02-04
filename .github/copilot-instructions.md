# CLAUDE.md

This file provides guidance to AI agents (Claude, Copilot, etc.) when working with code in this repository.

## Repository Overview

This repository contains Fish shell configuration files managed with `chezmoi`. The configuration is organized across multiple fish scripts that are sourced by the main `config.fish` file. These configuration files set up environment variables, aliases, abbreviations, and functions for everyday use.

## File Structure and Organization

- `config.fish`: Main entry point that sources other configuration files
- `vars.fish`: Global environment variables
- `abbrs.fish`: Command abbreviations for quick access to common commands
- `aliases.fish`: Command aliases
- `funcs.fish`: Custom functions for various tasks
- `os.fish`: OS-specific configuration (templated based on OS by chezmoi)
- `interactive.fish`: Configuration for interactive shell sessions (prompt, completions, plugins)
- `final.fish`: Runs at the end of config, e.g., for PATH tweaks
- `tools/`: Custom scripts and utilities
  - `sixkcd`: Script to display XKCD comics using Sixel graphics

## Plugins and Integrations

The configuration uses `fisher` for plugin management and includes integrations with:

- `starship`: Prompt customization (see `interactive.fish`)
- `catppuccin`: Theme
- `mise`: Runtime version manager (see `interactive.fish` and `os.fish`)
- `zoxide`: Directory navigator
- `atuin`: Shell history
- `direnv`/`shadowenv`: Directory/project-specific environments
- Completions and helpers for Docker, Kubernetes, cloud tools, and more

## Common Development Tasks

- Add environment variables to `vars.fish`
- Add abbreviations to `abbrs.fish`
- Add aliases to `aliases.fish`
- Add functions to `funcs.fish`
- Add OS-specific config to `os.fish`
- Add interactive shell config (prompt, completions, plugins) to `interactive.fish`
- Add any final PATH or tweaks to `final.fish`
- Add secrets to `secrets.fish` (not committed)

## Working with chezmoi

This repository is managed by `chezmoi`. Any changes should be added to chezmoi with:

```fish
chezmoi add <file>   # Add a file to chezmoi
chezmoi add --encrypt <file>  # Add a file to chezmoi and encrypt it
chezmoi apply         # Apply chezmoi changes
```

## Notes for AI Agents

- The prompt is managed by `starship`, not `tide`.
- Version management is handled by `mise`, not `asdf`.
- There is no `yank` or `yank-all` utility in this repo.
- `final.fish` is sourced last for any final tweaks.
- `sixkcd` is a MOTD XKCD script for terminals with Sixel support.
- Always check the actual file contents for up-to-date configuration and plugin usage.
