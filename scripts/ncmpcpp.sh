#!/bin/bash

# mpris
# systemctl --user --now enable mpd-mpris &

# player
tmux new-window -n 'music' 'ncmpcpp --screen playlist' \; \
  split-window -h -p 36 '~/.config/ncmpcpp/album_cover_art.sh'
tmux split-pane -v -p 40 'cava' \; select-pane -t 0 \; send-keys End
