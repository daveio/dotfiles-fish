# dotfiles-fish

Fish shell configuration. Comes as it is, maybe it's useful to someone.

Under the hood I use `chezmoi` to manage this, this published version is the output of the templates. Templated files are `config.fish` and `interactive.fish` which are modified based on the invoking OS.

You don't need to worry about this though, as I say, this repo contains the resolved templates for the macOS platform.

## Plugins

I use `fisher` to manage plugins. You can grab it from [**jorgebucaran/fisher**](https://github.com/jorgebucaran/fisher).

### Prompt

One of the plugins is `tide`, a better `fish` version of `powerlevel10k`. Once installed, it will start its configuration process, so just be aware of that. You can read more of its documentation at [**IlanCosman/tide**](https://github.com/IlanCosman/tide).

### Theme

I use the `rose-pine` theme because it is nifty as hell. More detail at [**rose-pine/fish**](https://github.com/rose-pine/fish). There are themes for most things under the [**rose-pine**](https://github.com/rose-pine) user if you like it and want to integrate it across your system.

### `asdf`

I use `asdf` to manage versions of development tools. One of the plugins integrates it.

More detail is available at [**asdf-vm/asdf**](https://github.com/asdf-vm/asdf).

It's set up for the latest version of `asdf` which has moved from a chunk of shellscript to a proper binary.

## Missing files

### `secrets.fish`

Create `secrets.fish` containing any secrets you want to keep private. It's just set up this way so I can commit the other files without having to worry about accidentally committing sensitive information.

Example:

```fish
set -gx API_KEY "your_api_key"
```
