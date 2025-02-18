# disable greeting message
set fish_greeting

# rose-pine theme
fish_config theme choose "Rosé Pine"

# iTerm2
source $HOME/.iterm2_shell_integration.fish

# Homebrew

  /opt/homebrew/bin/brew shellenv | source


# zoxide
zoxide init fish | source

# atuin via ctrl+r and not up arrow
set -gx ATUIN_NOBIND "true"
atuin init fish | source
bind \cr _atuin_search
bind -M insert \cr _atuin_search

# virtualfish
if set -q VIRTUAL_ENV
  echo -n -s (set_color -b blue white) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal) " "
end

# pnpm

  set -gx PNPM_HOME "/Users/dave/Library/pnpm"

if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# gcloud
source /Users/dave/.asdf/installs/gcloud/510.0.0/path.fish.inc
complete -c gcloud -f -a '(__fish_argcomplete_complete gcloud)'
complete -c gsutil -f -a '(__fish_argcomplete_complete gsutil)'

# sixkcd as motd
$HOME/.config/fish/tools/sixkcd
