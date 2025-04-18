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
    for i in *
        echo "$i"
        cd $i
        echo fetch
        git fetch --all --tags --prune --jobs=8 --recurse-submodules=yes
        echo pull
        git pull --stat --tags --prune --jobs=8 --recurse-submodules=yes
        echo out
        cd ..
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
