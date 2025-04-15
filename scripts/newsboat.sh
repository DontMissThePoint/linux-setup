#!/bin/sh

while true; do
    killall $(pidof newsboat);
    # check inside tmux environment
    [ -n "${TMUX}" ] && tmux new-window newsboat
    if [ $? -ne 0 ]; then
        exec newsboat && break
    else
        break
    fi
done
