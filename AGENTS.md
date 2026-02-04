# Agent Guide for dotfiles-fish

This repository contains Fish shell configuration files, managed via `chezmoi` but published as resolved templates.

## ⚡️ Quick Start

- **Main Config**: `config.fish` (sources everything else)
- **Plugin Manager**: `fisher` (plugins listed in `fish_plugins`)
- **Linting**: `trunk check` (uses Trunk)

## 📂 Project Structure

- **Core Config**:
  - `config.fish`: Entry point. Sources files in specific order.
  - `vars.fish`: Environment variables.
  - `abbrs.fish`: Abbreviations.
  - `aliases.fish`: Aliases.
  - `funcs.fish`: Custom functions.
  - `os.fish`: OS-specific settings (templated via chezmoi).
  - `interactive.fish`: Interactive session setup (Starship, Mise, Atuin).
  - `final.fish`: Final adjustments (PATH, etc.).
- **Components**:
  - `completions/`: Fish completion scripts (`.fish`).
  - `fish_plugins`: List of Fisher plugins.
  - `.trunk/`: Trunk configuration for linting.
- **Missing Files**:
  - `secrets.fish`: Intentionally gitignored. Contains secrets/tokens. Must be created manually.

## 🛠️ Commands

### Linting & Formatting

This project uses **Trunk** for linting and formatting.

- **Check all files**: `trunk check`
- **Format files**: `trunk fmt`
- **Enabled Linters**:
  - `actionlint` (GitHub Actions)
  - `markdownlint` (Markdown)
  - `prettier` (Formatting)
  - `trufflehog` (Secret scanning)
  - `yamllint` (YAML)
  - `shellcheck` (via extensions or trunk if configured, though mostly fish scripts here)

### Package Management

- **Fisher**: Used for fish plugins.
  - Update plugins: `fisher update`
  - Install from file: `fisher update` (reads `fish_plugins`)

## 🧬 Code Conventions

- **Syntax**: Standard Fish shell syntax.
- **Organization**:
  - Functions go in `funcs.fish` or `functions/` (autoloaded).
  - Aliases go in `aliases.fish`.
  - Abbreviations go in `abbrs.fish`.
- **Style**:
  - Use 4 spaces for indentation (implied by typical fish defaults, check file content to confirm).
  - Prefer `abbr` over `alias` for interactive shell shortcuts.

## ⚠️ Gotchas

1. **`secrets.fish`**: If code references variables like `$API_KEY`, they are likely defined in `secrets.fish`, which is not in the repo. Do not remove the source command.
2. **`os.fish`**: This file is technically a chezmoi template target. Edits here might be overwritten if re-generated from chezmoi, but in this repo, treat it as a source file.
3. **Dependencies**: Relies on external tools being installed:
   - `starship` (Prompt)
   - `mise` (Tool versioning)
   - `atuin` (Shell history)
   - `zoxide` (Directory jumping, likely)

## 🤖 CI/CD

- **GitHub Actions**: Workflows in `.github/workflows/`.
  - `claude.yml`: Likely a review or automated check workflow.
  - `devskim.yaml`: Security scanning.
