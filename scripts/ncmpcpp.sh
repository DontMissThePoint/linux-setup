#!/bin/bash

# mpris
# systemctl --user --now enable mpd-mpris &

# player
tmux new-window -n 'music' 'ncmpcpp --screen playlist' \; \
  split-window -h -p 36 '~/.config/ncmpcpp/album_cover_poller.sh 2>/dev/null'
tmux split-pane -v -p 40 \
  'ncmpcpp --config=~/.config/ncmpcpp/viz.conf -s search_engine 2>/dev/null' \; \
  send-keys End \; select-pane -t 0
