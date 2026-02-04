# Agent Instructions

This repository contains Fish shell configuration files managed with `chezmoi`.

## 📂 Code Structure

- **Core Config**:
  - `config.fish`: Entry point. Sources other files.
  - `vars.fish`: Global environment variables.
  - `abbrs.fish`: Abbreviations.
  - `aliases.fish`: Aliases.
  - `funcs.fish`: Utility functions.
  - `os.fish`: OS-specific configurations.
  - `interactive.fish`: Interactive session settings (prompt, etc).
  - `final.fish`: Last-loaded settings (PATH tweaks).

- **Directories**:
  - `completions/`: Fish completion scripts.
  - `bin/`: Helper scripts (e.g., `sixkcd` for Sixel XKCD comics).
  - `fish_plugins`: Fisher plugin list.

## 🛠 Workflows & Commands

### Chezmoi (Dotfile Management)

This repo is a `chezmoi` source.

- **Apply changes**: `chezmoi apply`
- **Add file**: `chezmoi add <file>`
- **Add secret**: `chezmoi add --encrypt <file>`
- **Diff**: `chezmoi diff`

### Development & Maintenance

- **Dependencies**: `deps` (Updates mise, trunk, node, ruby, rust, python deps)
- **Formatting/Linting**: `trunkfix` (Runs `trunk fmt` and `trunk check`)
- **Setup**: `devsetup` (Smart detection for project setup)
- **Committing**: `quickcommit` (Stages, AI-generates message via `oco`, commits, optional push)

### Key Utility Functions (`funcs.fish`)

- `ai`: Generates shell commands using Claude.
- `yank`: Fetches/pulls all git repos in the current directory.
- `dockerclean`: Cleans up docker resources.
- `gitclean`: Prunes and GCs git repo.

## 🧩 Dependencies & Tools

- **Shell**: Fish (v3+)
- **Plugin Manager**: `fisher`
- **Version Manager**: `mise` (not asdf)
- **Directory Navigation**: `zoxide`, `direnv`, `shadowenv`
- **History**: `atuin`
- **Prompt**: `starship` (configured in `interactive.fish`)
- **Theme**: `catppuccin`
- **Linter**: `trunk`
- **Secret Management**: `1Password` (referenced in `psclean`), `chezmoi` encryption.

## ⚠️ Important Notes

- **Secrets**: `secrets.fish` is git-ignored. Do not commit secrets.
- **Syntax**: Use strictly Fish syntax. No Bash/Zsh syntax (e.g., use `set -gx VAR val` not `export VAR=val`).
- **Symlinks**: Watch out for broken symlinks.
