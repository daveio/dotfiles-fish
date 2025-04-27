function nas-docker
    set -gx DOCKER_HOST tcp://nas-7t54.manticore-minor.ts.net:2376
    set -gx DOCKER_TLS_VERIFY 1
end

function le-fw
    lego -d fw.lan.sl1p.net -d fw.mgmt.lan.sl1p.net -d fw.private.lan.sl1p.net -d fw.guest.lan.sl1p.net -d fw.iot.lan.sl1p.net -d fw.fastlane.lan.sl1p.net -d fw.public.lan.sl1p.net -d private.external.lan.sl1p.net -d fastlane.external.lan.sl1p.net -d public.external.lan.sl1p.net -a --email dave@dave.io -k ec384 --dns dnsimple --dns.resolvers ns1.dnsimple.com --pem --pfx run
end

function fzf --wraps="fzf"
    set -Ux FZF_DEFAULT_OPTS "
	--color=fg:#908caa,bg:#191724,hl:#ebbcba
	--color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
	--color=border:#403d52,header:#31748f,gutter:#191724
	--color=spinner:#f6c177,info:#9ccfd8
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa
	"
    command fzf
end

function globals
    gem install rubygems-server
end

function cma
    chmod a-x $argv
    chezmoi add $argv
end

function cmae
    chmod a-x $argv
    chezmoi add --encrypt $argv
end

function github-auth
    set -gx GITHUB_TOKEN (gh auth token)
end

function kill-oco
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

            # Check if process was successfully killed
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
    # gh api --paginate "/repos/$REPONAME/actions/runs" | jq '.workflow_runs.[].id' | parallel -j 16 "echo {}; gh api --silent -X DELETE /repos/$REPONAME/actions/runs/{}"
    for i in (gh api --paginate "/repos/$REPONAME/actions/runs" | jq '.workflow_runs.[].id')
        echo $i
        gh api --silent -X DELETE /repos/$REPONAME/actions/runs/$i
    end
end

function yank-all
    for dir in *
        if test -d "$dir/.git"
            printf "%30s" "$dir  📡  "
            pushd $dir
            echo -n "[🚚 fetch] "
            git fetch --quiet --all --tags --prune --jobs=8 --recurse-submodules=yes
            echo -n "[🚜 pull] "
            git pull --quiet --stat --tags --prune --jobs=8 --recurse-submodules=yes
            popd
            echo
        end
    end
end

function queue-prs
    for i in *
        cd $i
        gh pr list | awk '{print $1}' | while read line
            trunk merge $line
        end
        cd ..
    end
end

function queue-local-prs
    gh pr list | awk '{print $1}' | while read line
        trunk merge $line
    end
end

function delete-issue
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

function delete-issues
    set -l parallelism 8
    if test (count $argv) -gt 0
        set parallelism $argv[1]
    end

    echo "Fetching all issues..."

    # Use a single call with a high limit to get all issues
    # Adding the --state all flag to include all issue states (open, closed)
    set -l all_issues (gh issue list --json number,title --limit 1000 --state all)

    # Check if the result is empty or not a valid JSON array
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

    # Check if there are more issues (in case we hit the limit)
    set -l remaining (gh issue list --json number --limit 1 --state all | jq 'length')
    if test $remaining -gt 0
        echo (set_color yellow)"There may be more issues remaining. Run the command again to continue."(set_color normal)
    end
end

function mise-install
    for i in gettext libdeflate pcre2 pkgconf tcl-tk xz
        if not brew list $i > /dev/null 2>&1
            brew install $i
        end
    end
    set -lxp CFLAGS -I/opt/homebrew/include
    set -lxp CPPFLAGS -I/opt/homebrew/include
    set -lxp LDFLAGS -L/opt/homebrew/lib
    mise install --yes
end
