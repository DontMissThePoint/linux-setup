#!/bin/bash

tmux new-window -n 'music' 'ncmpcpp --config=~/.config/ncmpcpp/catalog.conf' \; split-window -h -p 15 'clear && cover' \; send-keys PageDown
# tmux split-pane -v -p 20 ncmpcpp --config='~/.config/ncmpcpp/visualizer.conf' \; send-keys 8
