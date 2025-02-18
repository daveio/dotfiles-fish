# dotfiles-fish

Fish shell configuration. Comes as it is, maybe it's useful to someone.

Under the hood I use `chezmoi` to manage this, this published version is the output of the templates. Templated files are `config.fish` and `macos.fish` which are modified based on the invoking OS.

You don't need to worry about this though, as I say, this repo contains the resolved templates for the macOS platform.

## Missing files

### `secrets.fish`

Create `secrets.fish` containing any secrets you want to keep private. It's just set up this way so I can commit the other files without having to worry about accidentally committing sensitive information.

Example:

```fish
set -gx API_KEY "your_api_key"
```
