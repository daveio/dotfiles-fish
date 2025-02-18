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
set TORIFY torsocks -i
type -q $TORIFY[1] || set TORIFY

# [ Terminal Detection ] ######################################################
if test "$TERM_PROGRAM" != "iTerm.app"
  exit 0
end

# [ Functions ] ###############################################################

function error
  echo Error: $argv 1>&2
  exit 127
end

function wordwrap
  set width 60
  set defaultwidth 60

  test -z "$width"; and tty <&1 >/dev/null; and set width $defaultwidth
  test -z "$width"; and set width $COLUMNS
  test -z "$width"; and set width (tput cols <&1)
  test -z "$width"; and set width $defaultwidth

  set ww cat
  test -x /usr/bin/fmt; and set ww /usr/bin/fmt -w $width
  test -x /usr/bin/par; and set ww /usr/bin/par $width

  $ww
end

function fetch_url
  set url $argv[1]

  if type -q curl
    $TORIFY curl -sSL $url
  else if type -q wget
    $TORIFY wget --no-verbose --retry-on-host-error -O - -- $url
  end
end

function fetch_xkcd
  set xkcdnumber $argv[1]
  set url

  if test -n "$xkcdnumber"
    set url "https://xkcd.com/$xkcdnumber/info.0.json"
  else
    set url "https://xkcd.com/info.0.json"
  end

  fetch_url $url
end

function decode_xkcd
  python3 -c 'if __name__ == "__main__":
        import json
        import sys
        j = json.load(sys.stdin)
        for k in "num safe_title img year month day alt".split():
            print(j[k])'
end

# [ Main ] ####################################################################

set xkcd_data (fetch_xkcd $xkcdnumber | decode_xkcd) || error "Download failed"

set xkcd_number (echo $xkcd_data | awk 'NR==1')
set xkcd_safe_title (echo $xkcd_data | awk 'NR==2')
set xkcd_imgurl (echo $xkcd_data | awk 'NR==3')
set xkcd_year (echo $xkcd_data | awk 'NR==4')
set xkcd_month (echo $xkcd_data | awk 'NR==5')
set xkcd_day (echo $xkcd_data | awk 'NR==6')
set xkcd_alt (echo $xkcd_data | awk 'NR>6')

set xkcd_siximg (fetch_url $xkcd_imgurl | magick - -resize 250% - | img2sixel) || error "Image download failed"

echo $xkcd_siximg
echo $xkcd_alt | wordwrap
echo
