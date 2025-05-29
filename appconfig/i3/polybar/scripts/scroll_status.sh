#!/bin/bash

cmd="${0%/*}/get_status.sh $1"

~/.nix-profile/bin/zscroll -l 28 \
  --scroll-padding "$(printf ' %.0s' {1..8})" \
  -d 0.1 \
  -M "$cmd icon" \
  -m "none" "-b ''" \
  -m "browser" "-b '  '" \
  -m "netflix" "-b '󰝆  '" \
  -m "youtube" "-b '  '" \
  -m "prime" "-b '  '" \
  -m "spotify" "-b '  '" \
  -m "vlc" "-b '󰕼  '" \
  -m "mpv" "-b '  '" \
  -m "kdeconnect" "-b ' '" \
  -m "corridor" "-b ' '" \
  -U 3 -u t "$cmd" &

wait
