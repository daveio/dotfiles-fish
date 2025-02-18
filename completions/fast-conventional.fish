# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_fast_conventional_global_optspecs
	string join \n h/help V/version
end

function __fish_fast_conventional_needs_command
	# Figure out if the current invocation already has a command.
	set -l cmd (commandline -opc)
	set -e cmd[1]
	argparse -s (__fish_fast_conventional_global_optspecs) -- $cmd 2>/dev/null
	or return
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

function __fish_fast_conventional_using_subcommand
	set -l cmd (__fish_fast_conventional_needs_command)
	test -z "$cmd"
	and return 1
	contains -- $cmd[1] $argv
end

complete -c fast-conventional -n "__fish_fast_conventional_needs_command" -s h -l help -d 'Print help'
complete -c fast-conventional -n "__fish_fast_conventional_needs_command" -s V -l version -d 'Print version'
complete -c fast-conventional -n "__fish_fast_conventional_needs_command" -f -a "completion" -d 'Generate completion for shell'
complete -c fast-conventional -n "__fish_fast_conventional_needs_command" -f -a "editor" -d 'Edit a commit message'
complete -c fast-conventional -n "__fish_fast_conventional_needs_command" -f -a "validate" -d 'Validate a commit message is conventional'
complete -c fast-conventional -n "__fish_fast_conventional_needs_command" -f -a "example-config" -d 'Print an example configuration'
complete -c fast-conventional -n "__fish_fast_conventional_needs_command" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c fast-conventional -n "__fish_fast_conventional_using_subcommand completion" -s h -l help -d 'Print help'
complete -c fast-conventional -n "__fish_fast_conventional_using_subcommand editor" -s c -l config -d 'Configuration file' -r -F
complete -c fast-conventional -n "__fish_fast_conventional_using_subcommand editor" -s h -l help -d 'Print help'
complete -c fast-conventional -n "__fish_fast_conventional_using_subcommand validate" -s r -l repository -d 'Git repository to search in' -r -F
complete -c fast-conventional -n "__fish_fast_conventional_using_subcommand validate" -s c -l config -d 'Configuration file' -r -F
complete -c fast-conventional -n "__fish_fast_conventional_using_subcommand validate" -s h -l help -d 'Print help'
complete -c fast-conventional -n "__fish_fast_conventional_using_subcommand example-config" -s h -l help -d 'Print help'
complete -c fast-conventional -n "__fish_fast_conventional_using_subcommand help; and not __fish_seen_subcommand_from completion editor validate example-config help" -f -a "completion" -d 'Generate completion for shell'
complete -c fast-conventional -n "__fish_fast_conventional_using_subcommand help; and not __fish_seen_subcommand_from completion editor validate example-config help" -f -a "editor" -d 'Edit a commit message'
complete -c fast-conventional -n "__fish_fast_conventional_using_subcommand help; and not __fish_seen_subcommand_from completion editor validate example-config help" -f -a "validate" -d 'Validate a commit message is conventional'
complete -c fast-conventional -n "__fish_fast_conventional_using_subcommand help; and not __fish_seen_subcommand_from completion editor validate example-config help" -f -a "example-config" -d 'Print an example configuration'
complete -c fast-conventional -n "__fish_fast_conventional_using_subcommand help; and not __fish_seen_subcommand_from completion editor validate example-config help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
