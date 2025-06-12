#!/bin/bash

SESSION="double"
WINDOW="music"

# player
if ! tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "Error: tmux session '$SESSION' does not exist."
  exit 1
fi

# layout
if tmux list-windows -t "$SESSION" | grep -qE "^[0-9]+: $WINDOW\b"; then
  echo "Window '$WINDOW' already exists. Switching..."
  tmux select-window -t "$SESSION:$WINDOW"
  exit 0
fi

# right 35%: (cover)
# bottom 45%: (cava)
tmux new-window -t "$SESSION:" -n "$WINDOW" \; \
  send-keys -Rt "$SESSION:$WINDOW" 'ncmpcpp --config=~/.config/ncmpcpp/config' Enter \; \
  split-window -v -l 45% -t "$SESSION:$WINDOW" \; \
  send-keys -Rt "$SESSION:$WINDOW".1 'cava' Enter \; \
  select-pane -t "$SESSION:$WINDOW".0 \; \
  split-window -h -l 35% \; \
  send-keys -Rt "$SESSION:$WINDOW".2 "watch -n 2 \$HOME/.config/ncmpcpp/cover.sh" Enter \; \
  select-pane -t "$SESSION:$WINDOW".0 # playlist

# 'q' to quit
# tmux bind-key -T root q if-shell '[ "#{window_name}" = "'"$WINDOW"'" ]' "kill-window"
