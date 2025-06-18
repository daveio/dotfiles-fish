# set -gx AQUA_GLOBAL_CONFIG $HOME/.config/aqua/config.yaml
set -gx CLOUDFLARE_EMAIL dave@dave.io
set -gx DISABLE_ZELLIJ true
set -gx EDITOR "zed -w"
set -gx GITHUB_TOKEN (gh auth token)
set -gx HOMEBREW_BUNDLE_DUMP_NO_VSCODE 1
set -gx MONO_GAC_PREFIX /opt/homebrew
set -gx OLLAMA_HOST "http://localhost:11434"
set -gx OP_PLUGIN_ALIASES_SOURCED 1
# set -gx PYTHON_BUILD_FREE_THREADING 1
set -gx SERVERLESS_FRAMEWORK_FORCE_UPDATE true
set -gx SHOW_ITERM2_WARNING false
set -gx SLACK_TEAM_ID T03RUU56D
set -gx SRC $HOME/src
set -gx SRCHOME $SRC/github.com/daveio
set -gx TAILSCALE_IPV4 (tailscale ip -4)
set -gx TAILSCALE_IPV6 (tailscale ip -6)
set -gx THEFUCK_OVERRIDDEN_ALIASES br,d,dc,g,h,k,l,m,s,vi,vim
set -gx VIRTUAL_ENV_DISABLE_PROMPT true
