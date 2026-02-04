# disable greeting message
set fish_greeting

# Aqua
aqua completion fish | source

# mise
mise activate fish | source

# starship
starship init fish | source -

# zoxide
zoxide init fish | source

# pieces
pieces completion fish | source

# bunnylol.rs
bunnylol completion fish | source

# orb stack
source ~/.orbstack/shell/init2.fish 2>/dev/null

# opencode
fish_add_path /Users/dave/.opencode/bin
# kiro
string match -q "$TERM_PROGRAM" "kiro" and . (kiro --locate-shell-integration-path fish)

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
# fuck
thefuck --alias | source

# warp
# printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "fish" }}\x9c'
# upcloud upctl
upctl completion fish | source

# gcloud
complete -c gcloud -f -a '(__fish_argcomplete_complete gcloud)'
complete -c gsutil -f -a '(__fish_argcomplete_complete gsutil)'

# navi
navi widget fish | source

# windsurf
fish_add_path $HOME/.codeium/windsurf/bin

# lmstudio
fish_add_path $HOME/.lmstudio/bin
