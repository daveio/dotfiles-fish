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
    set -x PATH "/Applications/HTTP Toolkit.app/Contents/Resources/httptoolkit-server/overrides/path" $PATH;
    if command -v winpty >/dev/null 2>&1
        # Work around for winpty's hijacking of certain commands
        alias php=php
        alias node=node
    end
end
# --httptoolkit-end--

# warp
printf '\eP$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "fish" }}\x9c'

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/dave/.lmstudio/bin

# gcloud
source /Users/dave/.asdf/installs/gcloud/510.0.0/path.fish.inc
complete -c gcloud -f -a '(__fish_argcomplete_complete gcloud)'
complete -c gsutil -f -a '(__fish_argcomplete_complete gsutil)'
