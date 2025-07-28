function nas-docker -d "Set up Docker to use the NAS"
    set -gx DOCKER_HOST tcp://nas-7t54.manticore-minor.ts.net:2376
    set -gx DOCKER_TLS_VERIFY 1
end

function le-fw -d "Set up certs for the firewall"
    lego -d fw.lan.sl1p.net -d fw.mgmt.lan.sl1p.net -d fw.private.lan.sl1p.net -d fw.guest.lan.sl1p.net -d fw.iot.lan.sl1p.net -d fw.fastlane.lan.sl1p.net -d fw.public.lan.sl1p.net -d private.external.lan.sl1p.net -d fastlane.external.lan.sl1p.net -d public.external.lan.sl1p.net -a --email dave@dave.io -k ec384 --dns dnsimple --dns.resolvers ns1.dnsimple.com --pem --pfx run
end

function fzf --wraps="fzf" -d "Set up fzf"
    set -Ux FZF_DEFAULT_OPTS "\
    --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
    --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
    --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
    --color=selected-bg:#45475A \
    --color=border:#313244,label:#CDD6F4"
    command fzf
end

function cma -d "Add a file to chezmoi"
    chmod a-x $argv
    chezmoi add $argv
end

function cmae -d "Add a file to chezmoi and encrypt it"
    chmod a-x $argv
    chezmoi add --encrypt $argv
end

function github-auth -d "Authenticate with GitHub and set env var"
    set -gx GITHUB_TOKEN (gh auth token)
end

function kill-oco -d "Kill a hanging opencommit"
    echo "Searching for Node.js processes containing 'oco'..."
    set pids (ps aux | grep -i "[n]odejs.*oco\|[n]ode.*oco" | awk '{print $2}')
    if test (count $pids) -eq 0
        echo "No matching 'oco' processes found."
        return 0
    end
    echo Found (count $pids) "process(es) to kill:"
    for pid in $pids
        set process_info (ps -p $pid -o command= | string sub -l 50)
        echo "PID $pid: $process_info..."
    end
    read -l -P "Kill these processes? [y/N] " confirm
    if test "$confirm" = y -o "$confirm" = Y
        for pid in $pids
            echo "Killing process $pid..."
            kill -9 $pid
            if kill -0 $pid 2>/dev/null
                echo "Failed to kill process $pid!"
            else
                echo "Process $pid successfully terminated."
            end
        end
        echo "All matching 'oco' processes have been terminated."
    else
        echo "Operation canceled. No processes were killed."
    end
end

function wipe-workflows -d "Wipe all workflow runs for a GitHub repository"
    set -lx REPONAME $argv[1]
    echo "Wiping all workflow runs for $REPONAME..."
    gh api --paginate "/repos/$REPONAME/actions/runs" | jq '.workflow_runs.[].id' | parallel -j 16 \
        "echo {}; gh api --silent -X DELETE /repos/$REPONAME/actions/runs/{}"
    # for i in (gh api --paginate "/repos/$REPONAME/actions/runs" | jq '.workflow_runs.[].id')
    #     echo $i
    #     gh api --silent -X DELETE /repos/$REPONAME/actions/runs/$i
    # end
end

function wipe-caches -d "Wipe all GitHub Actions caches for a GitHub repository"
    set -lx REPONAME $argv[1]
    echo "Wiping all GitHub Actions caches for $REPONAME..."
    gh api --paginate "/repos/$REPONAME/actions/caches" | jq '.actions_caches[].id' | parallel -j 16 \
        "echo {}; gh api --silent -X DELETE /repos/$REPONAME/actions/caches/{}"
end

function delete-issue -d "Delete a GitHub issue from the current repository"
    set -l issue_number $argv[1]
    set -l issue_title $argv[2]
    if test -n "$issue_title"
        echo -n (set_color yellow)"Deleting "(set_color cyan)"$issue_number"(set_color normal)": $issue_title ... "
    else
        echo -n (set_color yellow)"Deleting issue "(set_color cyan)"$issue_number"(set_color normal)" ... "
    end
    gh issue delete --yes $issue_number
    echo (set_color green)"✓"(set_color normal)
end

function delete-issues -d "Delete all GitHub issues for the current repository"
    set -l parallelism 8
    if test (count $argv) -gt 0
        set parallelism $argv[1]
    end
    echo "Fetching all issues..."
    set -l all_issues (gh issue list --json number,title --limit 1000 --state all)
    if test -z "$all_issues" || test (echo $all_issues | jq 'if type == "array" then length else 0 end') -eq 0
        echo "No issues found to delete."
        return 0
    end
    set -l issues_found (echo $all_issues | jq 'length')
    echo "Found $issues_found issues to delete."
    echo "Processing $issues_found issues with parallelism $parallelism..."
    echo $all_issues | jq -r '.[] | "\(.number)\t\(.title)"' \
        | parallel -P $parallelism --colsep '\t' 'delete-issue {1} "{2}"'
    echo (set_color green)"Completed deleting all $issues_found issues"(set_color normal)
    set -l remaining (gh issue list --json number --limit 1 --state all | jq 'length')
    if test $remaining -gt 0
        echo (set_color yellow)"There may be more issues remaining. Run the command again to continue."(set_color normal)
    end
end

function yank -d "Fetch and pull all git repositories in the current directory"
    for dir in *
        if test -d "$dir/.git"
            printf "%30s" "$dir  📡  "
            pushd $dir
            echo -n "[🚚 fetch] "
            git fetch --quiet --all --prune --tags --prune-tags --recurse-submodules=yes
            echo -n "[🚜 pull] "
            git pull --quiet --all --prune --rebase
            popd
            echo
        end
    end
end

function js-clear-caches -d "Clear all JavaScript caches"
    rm -rf ~/.bun
    rm -rf ~/.npm
    rm -rf ~/Library/pnpm
    rm -rf ~/Library/Caches/deno
    deno clean
end

function czkawka -d "Run czkawka or krokiet"
    read -l -P "Run krokiet instead of czkawka? [y/N] " use_krokiet
    set -l use_krokiet (string lower "$use_krokiet")
    set -l cmd
    if test "$use_krokiet" = y -o "$use_krokiet" = yes
        set cmd "/Users/dave/.local/bin/krokiet"
    else
        set cmd "/Users/dave/.local/bin/czkawka"
    end
    eval $cmd $argv
end

function latest-commit -d "Get the latest commit hash on main for a GitHub repository"
    set -l repo $argv[1]
    gh api "repos/$repo/commits/main" --jq .sha
end

function psclean -d "Clean up processes which love to hang"
    pkill -9 git
    pkill -9 trunk
    pkill -9 ssh
    pkill -9 uvx
    pkill -9 1Password
    pkill -9 node
    pkill -9 semgrep
    pkill -9 -f "claude mcp serve"
    pkill -9 -f "mcp-server"
    pkill -9 -f "docker ai mcpserver"
    open /Applications/1Password.app
end

# QuickCommit Function - Your most used workflow (806 + 786 + 129 = 1,721 uses)
# Handles: git add -A .; oco --fgm --yes; push
function quickcommit --description "Smart git commit with oco and optional push"
    argparse 'p/push' 'm/message=' -- $argv
    or return 1

    # Always start with git add
    git add -A .
    if test $status -ne 0
        echo "❌ Failed to stage files"
        return 1
    end

    # Handle commit message
    if set -q _flag_message
        git commit -m "$_flag_message"
    else
        # Use oco for AI-generated commit message
        if command -q oco
            oco --fgm --yes
        else
            echo "⚠️ oco not found, using standard commit"
            git commit
        end
    end

    if test $status -ne 0
        echo "❌ Commit failed"
        return 1
    end

    echo "✅ Commit successful"

    # Optional push
    if set -q _flag_push
        git push
        if test $status -eq 0
            echo "✅ Push successful"
        else
            echo "❌ Push failed"
            return 1
        end
    end
end

# TrunkFix Function - Combines fmt and check (164 sequences found)
function trunkfix --description "Run trunk fmt -a followed by trunk check -a"
    argparse 'f/fix' -- $argv
    or return 1

    echo "🔧 Running trunk fmt -a..."
    trunk fmt -a
    if test $status -ne 0
        echo "❌ trunk fmt failed"
        return 1
    end

    echo "✅ Formatting complete"
    echo "🔍 Running trunk check -a..."

    if set -q _flag_fix
        trunk check -a --fix
    else
        trunk check -a
    end

    if test $status -eq 0
        echo "✅ All checks passed"
    else
        echo "⚠️ Some checks failed - review output above"
        return 1
    end
end

# DevSetup Function - Intelligent project setup
function devsetup --description "Smart development environment setup"
    echo "🚀 Setting up development environment..."

    # Check for package managers and setup accordingly
    if test -f bun.lockb -o -f bunfig.toml
        echo "📦 Detected Bun project"
        bun install
        and echo "✅ Dependencies installed"
        and bun dev
    else if test -f pnpm-lock.yaml
        echo "📦 Detected pnpm project"
        pnpm install
        and echo "✅ Dependencies installed"
        and pnpm dev
    else if test -f package-lock.json
        echo "📦 Detected npm project"
        npm install
        and echo "✅ Dependencies installed"
        and npm run dev
    else if test -f Gemfile
        echo "💎 Detected Ruby project"
        bundle install
        and echo "✅ Dependencies installed"
    else if test -f requirements.txt
        echo "🐍 Detected Python project"
        pip install -r requirements.txt
        and echo "✅ Dependencies installed"
    else if test -f Cargo.toml
        echo "🦀 Detected Rust project"
        cargo build
        and echo "✅ Dependencies installed"
    else
        echo "❓ Project type not detected, manual setup required"
        return 1
    end
end

# GitClean Function - Advanced git cleanup
function gitclean --description "Comprehensive git repository cleanup"
    echo "🧹 Starting git repository cleanup..."

    git fetch --prune
    and echo "✅ Fetched and pruned remote references"

    git gc --aggressive
    and echo "✅ Garbage collection complete"

    git remote prune origin
    and echo "✅ Pruned remote branches"

    # Show status
    echo "📊 Repository status:"
    git status --short
end

# DockerClean Function - Docker system cleanup
function dockerclean --description "Clean up Docker containers, images, and volumes"
    argparse 'a/all' 'f/force' -- $argv

    echo "🐳 Starting Docker cleanup..."

    # Stop all running containers
    set -l running_containers (docker ps -q)
    if test (count $running_containers) -gt 0
        echo "⏹️ Stopping running containers..."
        docker stop $running_containers
    end

    # Remove all stopped containers
    docker container prune -f
    and echo "✅ Removed stopped containers"

    # Remove unused networks
    docker network prune -f
    and echo "✅ Removed unused networks"

    # Remove unused volumes
    docker volume prune -f
    and echo "✅ Removed unused volumes"

    if set -q _flag_all
        # Remove all unused images (not just dangling)
        docker image prune -a -f
        and echo "✅ Removed all unused images"
    else
        # Remove only dangling images
        docker image prune -f
        and echo "✅ Removed dangling images"
    end

    echo "📊 Docker disk usage after cleanup:"
    docker system df
end

# ===============================================
# DEVELOPMENT WORKFLOW FUNCTIONS
# ===============================================

# Common workflow: clear then run command
function cc --description "Clear screen and run command"
    clear
    if test (count $argv) -gt 0
        eval $argv
    end
end

# Multi-up directories (based on 72 uses of "cd .. && cd ..")
function up --description "Go up multiple directories"
    if test (count $argv) -eq 0
        cd ..
    else
        set -l levels $argv[1]
        for i in (seq $levels)
            cd ..
        end
    end
    pwd
end

# Open in editor based on your patterns
function edit --description "Smart editor selection"
    if test (count $argv) -eq 0
        # Open current directory
        if command -q code
            code .
        else if command -q zed
            zed .
        else
            nvim .
        end
    else
        # Open specific files
        if command -q code
            code $argv
        else if command -q zed
            zed $argv
        else
            nvim $argv
        end
    end
end

# ===============================================
# UTILITY FUNCTIONS
# ===============================================

# Extract archives (common need)
function extract --description "Extract various archive formats"
    if test (count $argv) -ne 1
        echo "Usage: extract <archive>"
        return 1
    end

    set -l file $argv[1]

    if not test -f $file
        echo "File not found: $file"
        return 1
    end

    switch $file
        case "*.tar.bz2"
            tar xjf $file
        case "*.tar.gz"
            tar xzf $file
        case "*.bz2"
            bunzip2 $file
        case "*.rar"
            unrar x $file
        case "*.gz"
            gunzip $file
        case "*.tar"
            tar xf $file
        case "*.tbz2"
            tar xjf $file
        case "*.tgz"
            tar xzf $file
        case "*.zip"
            unzip $file
        case "*.Z"
            uncompress $file
        case "*.7z"
            7z x $file
        case "*"
            echo "Unknown archive format: $file"
            return 1
    end
end

# Find and replace in files (common development task)
function findreplace --description "Find and replace text in files"
    argparse 'e/ext=' -- $argv
    or return 1

    if test (count $argv) -lt 2
        echo "Usage: findreplace <search> <replace> [directory]"
        echo "Options: -e/--ext <extension> to limit to specific file types"
        return 1
    end

    set -l search_term $argv[1]
    set -l replace_term $argv[2]
    set -l directory $argv[3]

    if test -z "$directory"
        set directory "."
    end

    if set -q _flag_ext
        find $directory -name "*.$_flag_ext" -type f -exec sed -i '' "s/$search_term/$replace_term/g" {} +
    else
        find $directory -type f -exec sed -i '' "s/$search_term/$replace_term/g" {} +
    end

    echo "🧑🏻‍🎤 Find and replace complete"
end

function latest --description "Get the latest commit on main (or master) for a GitHub repository"
    if test (count $argv) -eq 0
        echo "Usage: latest <username/reponame>"
        return 1
    end
    set -l repo $argv[1]
    set -l sha (gh api "repos/$repo/commits/main" --jq .sha 2>/dev/null)
    if test -z "$sha"
        set sha (gh api "repos/$repo/commits/master" --jq .sha 2>/dev/null)
    end
    if test -z "$sha"
        echo "Error: Unable to fetch latest commit for $repo"
        return 1
    end
    echo $sha
end

function ai --description "AI assistant for generating shell commands"
    argparse 'x/execute' 'f/force' -- $argv
    or return 1

    # Configurable guardrails: patterns to match against potentially dangerous commands
    set -l dangerous_patterns \
        "*rm *" \
        "*chmod -R 777 /*" \
        "*> /dev/sd*" \
        "*dd if=*of=/dev/*" \
        "*mkfs*" \
        "*fdisk*" \
        "*:(){ :|:& };:*" \
        "*curl*|*sh*" \
        "*wget*|*sh*"

    set -l system_prompt "You must output ONLY a single shell command that accomplishes the requested task. Check the --help for the command, and the man page with 'man foo | cat'. NOTABLE PITFALL: BSD vs. GNU versions of tools, which have the same name but different parameters. Adapt your command if necessary. Do not perform the task yourself. Do not output any explanation, markdown formatting, or multiple lines. Output exactly one executable shell command and nothing else."
    set -l ai_output
    set -l prompt

    if test (count $argv) -eq 0
        # No arguments provided, check if gum is available
        if not command -q gum
            echo "❌  Error: gum is not available for interactive prompts."
            echo
            echo "    Install gum from https://github.com/charmbracelet/gum or"
            echo "    invoke this function by specifying the prompt directly:"
            echo
            echo "    ai [PROMPT]"
            echo
            return 1
        end

        set prompt (gum write --header "Enter your prompt" --placeholder "Type your prompt here..." --width 80 --height 10)

        # Check if user cancelled (empty prompt)
        if test -z "$prompt"
            echo "❌ Cancelled by user"
            return 1
        end
    else
        # Arguments provided, use them as the prompt
        set prompt "$argv"
    end

    # Escape quotes and special characters in the prompt to prevent command injection
    set prompt (string escape -- $prompt)

    echo "🤖 Generating command..."

    # Try different package managers to run claude code
    if command -q bun
        set ai_output (bun x @anthropic-ai/claude-code --append-system-prompt "$system_prompt" -p "$prompt" 2>/dev/null)
    else if command -q deno
        set ai_output (deno run -A npm:@anthropic-ai/claude-code --append-system-prompt "$system_prompt" -p "$prompt" 2>/dev/null)
    else if command -q pnpm
        set ai_output (pnpm dlx @anthropic-ai/claude-code --append-system-prompt "$system_prompt" -p "$prompt" 2>/dev/null)
    else if command -q yarn
        set ai_output (yarn dlx @anthropic-ai/claude-code --append-system-prompt "$system_prompt" -p "$prompt" 2>/dev/null)
    else if command -q npx
        set ai_output (npx -y @anthropic-ai/claude-code --append-system-prompt "$system_prompt" -p "$prompt" 2>/dev/null)
    else if command -q claude
        set ai_output (claude --append-system-prompt "$system_prompt" -p "$prompt" 2>/dev/null)
    else
        echo "❌  Error: No suitable package manager or claude command found."
        echo "    Please install bun, deno, pnpm, yarn, npm, or claude code directly"
        return 1
    end

    # Check if AI command failed or returned empty output
    if test $status -ne 0
        echo "❌  Error: Failed to communicate with AI service"
        return 1
    end

    if test -z "$ai_output"
        echo "❌  Error: AI service returned no output"
        return 1
    end

    # Remove code blocks, trim whitespace, and get the actual command
    # Handle various markdown formats and clean up output
    set -l command (echo "$ai_output" | sed -E 's/```[a-zA-Z0-9]*//g; s/```//g' | string trim | head -n 1)

    # Validate that we got a non-empty command
    if test -z "$command"
        echo "❌  Error: AI returned empty command after processing"
        echo "Raw output: $ai_output"
        return 1
    end

    # Check for potentially dangerous commands using configurable patterns
    set -l is_dangerous false
    for pattern in $dangerous_patterns
        if string match -q "$pattern" "$command"
            set is_dangerous true
            break
        end
    end

    if set -q _flag_execute
        # Execute mode (-x flag specified)
        if test "$is_dangerous" = true
            if set -q _flag_force
                # Both -x and -f specified: skip guardrails and execute
                echo "⚠️  FORCE MODE: Executing potentially dangerous command without guardrails"
                echo "⚡ Executing: $command"
                eval $command
            else
                # Only -x specified: refuse to execute dangerous command
                echo "❌  SAFETY: Potentially destructive command detected, refusing to auto-execute"
                echo "🤖 Generated command:"
                echo "$command"
                echo ""
                echo "💡 Use --force (-f) with --execute (-x) to bypass safety checks, or run without --execute for confirmation prompt"
                return 1
            end
        else
            # Not dangerous: execute immediately
            echo "⚡ Executing: $command"
            eval $command
        end
    else
        # Interactive mode (no -x flag): show command and ask for confirmation
        echo "🤖 Generated command:"
        echo "$command"

        # Show warning if dangerous (ignoring -f flag in interactive mode)
        if test "$is_dangerous" = true
            echo ""
            echo "⚠️  WARNING: This command appears potentially destructive!"
        end

        echo ""
        read -l -P "Execute this command? [y/N] " confirm
        if test "$confirm" = y -o "$confirm" = Y
            echo "⚡ Executing..."
            eval $command
        else
            echo "❌ Execution cancelled"
        end
    end
end
