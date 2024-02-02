#urxvt -e sh -c "tmux setw status off; wmctrl -r :ACTIVE: -b add,fullscreen; tmux splitw -l90% \; send-keys -Rt%0 \"genact -i5 -s3\" Enter"
