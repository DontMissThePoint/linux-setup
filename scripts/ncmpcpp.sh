#!/bin/bash

tmux new-window -n 'music' 'ncmpcpp --screen playlist' \; split-window -h -p 15 '~/.config/ncmpcpp/album_cover_poller.sh'
tmux split-pane -v -p 20 'ncmpcpp --config=~/.config/ncmpcpp/viz.conf --screen visualizer' \; send-keys 8
