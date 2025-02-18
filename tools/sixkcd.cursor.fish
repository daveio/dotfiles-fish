#!/usr/bin/env fish

# Display an xkcd comic using sixel graphics. Show the comic <number> if
# given, or the latest comic by default.
#
# Press any key to show the alt text and exit.

# Dependencies:
# - img2sixel ("apt-get install libsixel-bin")
# - python 3.x ("apt-get install python3")
# - curl or wget ("apt-get install curl")
# - torsocks (optional, make requests through tor)

# [ User Parameters ] #########################################################

set xkcdnumber $argv[1]

# [ Global Configuration ] ####################################################

set -l TORIFY (command -v torsocks)
if not set -q TORIFY
    set TORIFY ""
end

# [ Terminal Detection ] ######################################################

if test $TERM_PROGRAM != "iTerm.app"
    exit 0
end

# [ Functions ] ###############################################################

# Print a message to standard error and exit with a non-zero status code

function error
    echo "Error: $*" >&2
    exit 127
end

# Word Wrap (stdin -> stdout) with auto terminal width detection
#
# Prefer "par" if detected, otherwise fall back via "fmt" to "cat".

function wordwrap
    set width "60"
    set defaultwidth "60"
    set ww (cat)
    if not set -q width; or test -t 1
        set width $defaultwidth
    end
    if not set -q width; or test -t 1
        set width $COLUMNS
    end
    if not set -q width; or test -t 1
        set width (tput cols)
    end
    if not set -q width
        set width $defaultwidth
    end
    if test -x /usr/bin/fmt
        set ww (command -v fmt) -w $width
    end
    if test -x /usr/bin/par
        set ww (command -v par) $width
    end
    $ww
end

# Fetch URL and output contents to stdout

function fetch_url
    set url $argv[1]
    if command -v curl
        $TORIFY curl -sSL $url
    else if command -v wget
        $TORIFY wget --no-verbose --retry-on-host-error -O - -- $url
    end
end

# Fetch xkcd metadata by its comic number, or latest if omitted.
# Writes to stdout.

function fetch_xkcd
    set xkcdnumber $argv[1]
    set url ""
    if test -n $xkcdnumber
        set url "https://xkcd.com/"$xkcdnumber"/info.0.json"
    else
        set url "https://xkcd.com/info.0.json"
    end
    fetch_url $url
end

# Read xkcd json from stdin, output selected values on stdout:
# Line 1: xkcd number
# Line 2: safe_title
# Line 3: URL of comic image
# Line 4: year
# Line 5: month
# Line 6: day
# Line 7+: "Alt" text

function decode_xkcd
    python3 -c 'if __name__ == "__main__":
        import json
        import sys
        j = json.load(sys.stdin)
        for k in "num safe_title img year month day alt".split():
            print(j[k])'
end

# [ Main ] ####################################################################

# Display xkcd number ASAP if known, but don't advance the line, so we
# can overwrite it with json data when that arrives. Doing it this way
# allows us to have a single code path, regardless of whether we already
# know the xkcd number.

# Download and extract

set xkcd_data (fetch_xkcd $xkcdnumber | decode_xkcd)
or error "Download failed"

set xkcd_number (echo $xkcd_data | awk 'NR==1')
set xkcd_safe_title (echo $xkcd_data | awk 'NR==2')
set xkcd_imgurl (echo $xkcd_data | awk 'NR==3')
set xkcd_year (echo $xkcd_data | awk 'NR==4')
set xkcd_month (echo $xkcd_data | awk 'NR==5')
set xkcd_day (echo $xkcd_data | awk 'NR==6')
set xkcd_alt (echo $xkcd_data | awk 'NR>6')

# Display (before image)

# Download image

set xkcd_siximg (fetch_url $xkcd_imgurl | magick - -resize 250% - | img2sixel)
or error "Image download failed"

# Display (image, alt text)

echo $xkcd_siximg
echo $xkcd_alt | wordwrap
echo
