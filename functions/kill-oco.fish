function kill-oco
    echo "Searching for Node.js processes containing 'oco'..."
    
    # Find nodejs processes with "oco" in their command line
    # Use grep -v grep to exclude the grep process itself
    set pids (ps aux | grep -i "[n]odejs.*oco\|[n]ode.*oco" | awk '{print $2}')
    
    if test (count $pids) -eq 0
        echo "No matching 'oco' processes found."
        return 0
    end
    
    echo "Found" (count $pids) "process(es) to kill:"
    
    for pid in $pids
        set process_info (ps -p $pid -o command= | string sub -l 50)
        echo "PID $pid: $process_info..."
    end
    
    # Ask for confirmation before killing
    read -l -P "Kill these processes? [y/N] " confirm
    
    if test "$confirm" = "y" -o "$confirm" = "Y"
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

