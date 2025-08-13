# Executed at the end

function mise --wraps="mise" -d "Wrapper for mise that blocks 'mise implode'"
    # Block any attempt to run the destructive 'implode' subcommand
    if test (count $argv) -gt 0
        # Block if the first argument starts with 'implode' or if any argument equals 'implode'
        if string match -q -- "implode*" "$argv[1]"
            echo "❌ Refusing to run 'mise implode' (disabled to prevent accidental destruction)."
            return 1
        end
        if contains -- "implode" $argv
            echo "❌ Refusing to run 'mise implode' (disabled to prevent accidental destruction)."
            return 1
        end
    end
    command mise $argv
end
