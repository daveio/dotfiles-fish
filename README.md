# dotfiles-fish

Fish shell configuration. Comes as it is, maybe it's useful to someone.

Under the hood I use `chezmoi` to manage this; this published version is the output of the templates.

The only templated file is `os.fish`, which is modified based on the invoking OS.

More about `chezmoi` at [**twpayne/chezmoi**](https://github.com/twpayne/chezmoi).

You don't need to worry about this, though; as I say, this repo contains the resolved templates for the macOS platform.

## Plugins & Integrations

I use `fisher` to manage plugins. You can grab it from [**jorgebucaran/fisher**](https://github.com/jorgebucaran/fisher).

### Prompt

The prompt is managed by [`starship`](https://starship.rs/), a fast, cross-shell prompt. It is initialized in `interactive.fish`.

### Theme

I use the [`catppuccin`](https://github.com/catppuccin/fish) theme for pretty much everything. There are Catppuccin themes for many tools if you want a consistent look across your system.

### `mise`

I use [`mise`](https://github.com/jdx/mise) to manage versions of development tools. Completions and activation are handled in `interactive.fish` and `os.fish`.

## Notable Files

- `config.fish`: Main entry point, sources all other config files
- `vars.fish`: Global environment variables
- `abbrs.fish`: Command abbreviations
- `aliases.fish`: Command aliases
- `funcs.fish`: Custom functions
- `os.fish`: OS-specific configuration (templated)
- `interactive.fish`: Interactive shell setup (prompt, completions, plugins)
- `final.fish`: Runs at the end of config, e.g., for PATH tweaks
- `tools/sixkcd`: Shows XKCD comics as MOTD using Sixel graphics (see comments in script for config)

## `sixkcd`

This repo includes `sixkcd`, a script (originally `bash`) which I've adapted and ported to `fish` from [**csdvrx/sixel-testsuite**](https://github.com/csdvrx/sixel-testsuite). It uses Sixel graphics to show the current `xkcd` and its alt text as the MOTD. Read the comments if you have any trouble with it—there are a couple of configuration options.

Sixel graphics are only supported in certain terminals. `iTerm2` fully supports them, and that's what I use. You can check support for your terminal at [**Are We Sixel Yet?**](https://www.arewesixelyet.com).

If your terminal does not support Sixel graphics, and the terminal detection fails for any reason or is turned off, the script will spew out printable characters on startup.

## Missing files

### `secrets.fish`

Create `secrets.fish` containing any secrets you want to keep private. It's just set up this way so I can commit the other files without having to worry about accidentally committing sensitive information.

Example:

```fish
set -gx API_KEY "your_api_key"
```
