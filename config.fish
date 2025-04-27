source $HOME/.config/fish/secrets.fish
source $HOME/.config/fish/vars.fish
source $HOME/.config/fish/abbrs.fish
source $HOME/.config/fish/aliases.fish
source $HOME/.config/fish/funcs.fish

if status is-interactive
    source $HOME/.config/fish/os.fish
    source $HOME/.config/fish/interactive.fish
end


# Added by Windsurf
fish_add_path /Users/dave/.codeium/windsurf/bin

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/dave/.lmstudio/bin
# End of LM Studio CLI section

