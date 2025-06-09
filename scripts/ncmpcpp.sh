#!/bin/bash

# mpris
# systemctl --user --now enable mpd-mpris &

# player
tmux new-window -n 'music' -t double: 'ncmpcpp --screen playlist --config=~/.config/ncmpcpp/config' \; \
  split-pane -v -l 45% 'cava' \; select-pane -t double:0
tmux split-window -h -l 35% "$HOME/.config/ncmpcpp/cover.sh 2>/dev/null" \;
  select-pane -t :0 \; send-keys Home
