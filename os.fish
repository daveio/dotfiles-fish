# -*- mode: go-template; tab_size: 4; hard_tabs: false; -*-


    # macOS
    /opt/homebrew/bin/brew shellenv | source
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
    if [ -n "$HTTP_TOOLKIT_ACTIVE" ]
        # When HTTP Toolkit is active, we inject various overrides into PATH
        set -x PATH "/Applications/HTTP Toolkit.app/Contents/Resources/httptoolkit-server/overrides/path" $PATH
        if command -v winpty >/dev/null 2>&1
            # Work around for winpty's hijacking of certain commands
            alias php=php
            alias node=node
        end
    end
    if test -d (brew --prefix)"/share/fish/completions"
        set -p fish_complete_path (brew --prefix)/share/fish/completions
    end
    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
        set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end
    set HB_CNF_HANDLER (brew --repository)"/Library/Taps/homebrew/homebrew-command-not-found/handler.fish"
    if test -f $HB_CNF_HANDLER
        source $HB_CNF_HANDLER
    end
    source $HOME/.iterm2_shell_integration.fish

