set -gx AQUA_API_KEY $AVALON_API_KEY
set -gx CF_API_EMAIL $CLOUDFLARE_EMAIL
set -gx CF_API_KEY $CLOUDFLARE_API_KEY
set -gx CLOUDFLARE_EMAIL dave@dave.io
set -gx CLOUDFLARE_R2_HOSTNAME $CLOUDFLARE_ACCOUNT_ID.r2.cloudflarestorage.com
set -gx DISABLE_ZELLIJ true
set -gx DOMAINR_API_KEY $RAPIDAPI_API_KEY
set -gx EDITOR "code --wait"
set -gx GOOGLE_CLOUD_PROJECT sl1p-production
set -gx HOMEBREW_BUNDLE_DUMP_NO_VSCODE 1
set -gx HOMEBREW_DISPLAY_INSTALL_TIMES 1
set -gx HORDE_USERNAME daveio
set -gx MCP_TIMEOUT 31556952 # 1 year, should be enough for MA Sequential Thinking. Affects Claude Code.
set -gx META_MCP_API_KEY $METAMCP_API_KEY
set -gx MONO_GAC_PREFIX /opt/homebrew
set -gx OLLAMA_HOST "http://localhost:11434"
set -gx OP_PLUGIN_ALIASES_SOURCED 1
set -gx PIPEDREAM_WORKSPACE_ID o_zwIXEmW
set -gx QDRANT_HOSTNAME 303cc87b-ddb2-4e49-b6b5-130028595e74.europe-west3-0.gcp.cloud.qdrant.io
set -gx QDRANT_PORT 6333
set -gx SEMGREP_API_KEY $SEMGREP_APP_TOKEN
set -gx SERVERLESS_FRAMEWORK_FORCE_UPDATE true
set -gx SHOW_ITERM2_WARNING false
set -gx SLACK_TEAM_ID T03RUU56D
set -gx SRC $HOME/src
set -gx SRCHOME $SRC/github.com/daveio
set -gx TAILSCALE_IPV4 (tailscale ip -4)
set -gx TAILSCALE_IPV6 (tailscale ip -6)
set -gx THEFUCK_OVERRIDDEN_ALIASES br,d,dc,g,h,k,l,m,s,vi,vim
set -gx UPLOADTHING_TOKEN $UPLOADTHING_API_KEY
set -gx VIRTUAL_ENV_DISABLE_PROMPT true
