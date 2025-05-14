function nas-docker -d "Set up Docker to use the NAS"
    set -gx DOCKER_HOST tcp://nas-7t54.manticore-minor.ts.net:2376
    set -gx DOCKER_TLS_VERIFY 1
end

function le-fw -d "Set up certs for the firewall"
    lego -d fw.lan.sl1p.net -d fw.mgmt.lan.sl1p.net -d fw.private.lan.sl1p.net -d fw.guest.lan.sl1p.net -d fw.iot.lan.sl1p.net -d fw.fastlane.lan.sl1p.net -d fw.public.lan.sl1p.net -d private.external.lan.sl1p.net -d fastlane.external.lan.sl1p.net -d public.external.lan.sl1p.net -a --email dave@dave.io -k ec384 --dns dnsimple --dns.resolvers ns1.dnsimple.com --pem --pfx run
end

function fzf --wraps="fzf" -d "Set up fzf"
    set -Ux FZF_DEFAULT_OPTS "\
    --color=bg+:#414559,bg:#303446,spinner:#F2D5CF,hl:#E78284 \
    --color=fg:#C6D0F5,header:#E78284,info:#CA9EE6,pointer:#F2D5CF \
    --color=marker:#BABBF1,fg+:#C6D0F5,prompt:#CA9EE6,hl+:#E78284 \
    --color=selected-bg:#51576D \
    --color=border:#414559,label:#C6D0F5"
    command fzf
end

function globals -d "Set up global packages which mise has trouble with"
    gem install rubygems-server
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
    # gh api --paginate "/repos/$REPONAME/actions/runs" | jq '.workflow_runs.[].id' | parallel -j 16 "echo {}; gh api --silent -X DELETE /repos/$REPONAME/actions/runs/{}"
    for i in (gh api --paginate "/repos/$REPONAME/actions/runs" | jq '.workflow_runs.[].id')
        echo $i
        gh api --silent -X DELETE /repos/$REPONAME/actions/runs/$i
    end
end

function yank-all -d "Fetch and pull all git repositories in the current directory"
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

function queue-prs -d "Queue pull requests for all git repositories in the current directory with Trunk.io"
    for i in *
        cd $i
        gh pr list | awk '{print $1}' | while read line
            trunk merge $line
        end
        cd ..
    end
end

function queue-local-prs -d "Queue pull requests for the current repository with Trunk.io"
    gh pr list | awk '{print $1}' | while read line
        trunk merge $line
    end
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

function mw --wraps mise -a command args -d "Run mise ensuring dependencies and flags"
    for i in gettext libdeflate pcre2 pkgconf tcl-tk xz
        if not brew list $i >/dev/null 2>&1
            brew install $i
        end
    end
    set -l flags -O3 -mcpu=apple-m4
    set -lxp CFLAGS -I/opt/homebrew/include $flags
    set -lxp CPPFLAGS -I/opt/homebrew/include $flags
    set -lxp LDFLAGS -L/opt/homebrew/lib
    if test "$command" = install -o "$command" = upgrade
        mise $command --yes $args
    else
        mise $command $args
    end
end

