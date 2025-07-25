source $HOME/.config/fish/secrets.fish
source $HOME/.config/fish/vars.fish
source $HOME/.config/fish/abbrs.fish
source $HOME/.config/fish/aliases.fish
source $HOME/.config/fish/funcs.fish

if status is-interactive
    source $HOME/.config/fish/interactive.fish
    source $HOME/.config/fish/os.fish
end

source $HOME/.config/fish/final.fish


# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/dave/.lmstudio/bin
# End of LM Studio CLI section


# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

