source $HOME/.config/fish/secrets.fish
source $HOME/.config/fish/vars.fish
source $HOME/.config/fish/abbrs.fish
source $HOME/.config/fish/aliases.fish
source $HOME/.config/fish/funcs.fish

if status is-interactive
  source $HOME/.config/fish/interactive.fish
  
    # BEGIN macOS
      # Homebrew
      /opt/homebrew/bin/brew shellenv | source
      # pnpm
      set -gx PNPM_HOME "/Users/dave/Library/pnpm"
      if not string match -q -- $PNPM_HOME $PATH
        set -gx PATH "$PNPM_HOME" $PATH
      end
    # END macOS
  
end
