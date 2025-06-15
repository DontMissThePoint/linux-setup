#!/bin/bash

SESSION="double"
WINDOW="Music"

# daemon
systemctl --user enable mpd.service mpd.socket &

# player
if ! tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "Error: tmux session '$SESSION' does not exist."
  exit 1
fi

# layout
if tmux list-windows -t "$SESSION" | grep -qE "^[0-9]+: $WINDOW\b"; then
  echo "'$WINDOW' now playing..."
  tmux select-window -t "$SESSION:$WINDOW"
  exit 0
fi

# bottom 45%: (cava)
tmux new-window -t "$SESSION:" -n "$WINDOW" \; \
  send-keys -Rt "$SESSION:$WINDOW" 'ncmpcpp --config=~/.config/ncmpcpp/config' Enter \; \
  split-window -v -l 45% -t "$SESSION:$WINDOW" \; \
  send-keys -Rt "$SESSION:$WINDOW".1 'cava' Enter \; \
  select-pane -t "$SESSION:$WINDOW".0 \; \
  select-pane -t "$SESSION:$WINDOW".0 # playlist

# '&' to quit
# <Prefix> & for killing a window
# <Prefix> x for killing a pane
