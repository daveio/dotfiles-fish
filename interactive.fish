# disable greeting message
set fish_greeting

# iTerm2
source $HOME/.iterm2_shell_integration.fish

# mise
mise activate fish | source

# zoxide
zoxide init fish | source

# atuin via ctrl+r and not up arrow
set -gx ATUIN_NOBIND true
atuin init fish | source
bind \cr _atuin_search
bind -M insert \cr _atuin_search

# virtualfish
if set -q VIRTUAL_ENV
    echo -n -s (set_color -b blue white) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal) " "
end

# sixkcd as motd
# $HOME/.config/fish/tools/sixkcd

if test $DISABLE_ZELLIJ != true
    set ZELLIJ_AUTO_ATTACH true
    set ZELLIJ_AUTO_EXIT true
    eval (zellij setup --generate-auto-start fish | string collect)
end

# krew
set -q KREW_ROOT; and set -gx PATH $PATH $KREW_ROOT/.krew/bin; or set -gx PATH $PATH $HOME/.krew/bin

# kubeswitch
switcher init fish | source
switcher completion fish | source

# docker
docker completion fish | source

# 1Password CLI plugins
source ~/.config/op/plugins.sh

# shadowenv
shadowenv init fish | source

# direnv
direnv hook fish | source

# Homebrew completions
if test -d (brew --prefix)"/share/fish/completions"
    set -p fish_complete_path (brew --prefix)/share/fish/completions
end
if test -d (brew --prefix)"/share/fish/vendor_completions.d"
    set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
end

# homebrew-command-not-found
set HB_CNF_HANDLER (brew --repository)"/Library/Taps/homebrew/homebrew-command-not-found/handler.fish"
if test -f $HB_CNF_HANDLER
    source $HB_CNF_HANDLER
end

# --httptoolkit--
# This section will be reset each time a HTTP Toolkit terminal is opened
if [ -n "$HTTP_TOOLKIT_ACTIVE" ]
    # When HTTP Toolkit is active, we inject various overrides into PATH
    set -x PATH "/Applications/HTTP Toolkit.app/Contents/Resources/httptoolkit-server/overrides/path" $PATH

    if command -v winpty >/dev/null 2>&1
        # Work around for winpty's hijacking of certain commands
        alias php=php
        alias node=node
    end
end
# --httptoolkit-end--

# warp
# printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "fish" }}\x9c'

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/dave/.lmstudio/bin

# gcloud
# source /Users/dave/.asdf/installs/gcloud/511.0.0/path.fish.inc
complete -c gcloud -f -a '(__fish_argcomplete_complete gcloud)'
complete -c gsutil -f -a '(__fish_argcomplete_complete gsutil)'

# tide prompt
set -gx tide_right_prompt_items status vi_mode private_mode os jobs shlvl status cmd_duration context jobs direnv node python rustc java php pulumi ruby go aws gcloud kubectl distrobox toolbox terraform nix_shell crystal elixir zig time

# monokai theme
set fish_color_normal F8F8F2 # the default color
set fish_color_command F92672 # the color for commands
set fish_color_quote E6DB74 # the color for quoted blocks of text
set fish_color_redirection AE81FF # the color for IO redirections
set fish_color_end F8F8F2 # the color for process separators like ';' and '&'
set fish_color_error F8F8F2 --background=F92672 # the color used to highlight potential errors
set fish_color_param A6E22E # the color for regular command parameters
set fish_color_comment 75715E # the color used for code comments
set fish_color_match F8F8F2 # the color used to highlight matching parenthesis
set fish_color_search_match --background=49483E # the color used to highlight history search matches
set fish_color_operator AE81FF # the color for parameter expansion operators like '*' and '~'
set fish_color_escape 66D9EF # the color used to highlight character escapes like '\n' and '\x70'
set fish_color_cwd 66D9EF # the color used for the current working directory in the default prompt
set fish_pager_color_prefix F8F8F2 # the color of the prefix string, i.e. the string that is to be completed
set fish_pager_color_completion 75715E # the color of the completion itself
set fish_pager_color_description 49483E # the color of the completion description
set fish_pager_color_progress F8F8F2 # the color of the progress bar at the bottom left corner
set fish_pager_color_secondary F8F8F2 # the background color of the every second completion
