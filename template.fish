
  # BEGIN macOS
    # Homebrew
    /opt/homebrew/bin/brew shellenv | source
    # pnpm
    set -gx PNPM_HOME "/Users/dave/Library/pnpm"
    if not string match -q -- $PNPM_HOME $PATH
      set -gx PATH "$PNPM_HOME" $PATH
    end
  # END macOS

