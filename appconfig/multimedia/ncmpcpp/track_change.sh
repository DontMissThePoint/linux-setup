#!/bin/bash

file="$MUSIC_DIR/$(mpc --format %file% current)"
album="${file%/*}"
err=$(ffmpeg -loglevel 16 -y -i "$file" -an -vcodec copy $EMB_COVER 2>&1)
if [ "$err" != "" ]; then
  art=$(find "$album" -maxdepth 1 | grep -m 1 ".*\.\(jpg\|png\|gif\|bmp\)")
else
  art=$EMB_COVER
fi
if [ "$art" = "" ]; then
  art="$HOME/.config/ncmpcpp/default_cover.jpg"
fi
ffmpeg -loglevel 0 -y -i "$art" -vf "scale=$COVER_SIZE:-1" "$COVER"

notify-send -r 27072 "Now Playing" "$(mpc --format '%title% \n%artist% - %album%' current 2>/dev/null)" -i "$art"
