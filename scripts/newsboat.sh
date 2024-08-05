#!/bin/sh

while true; do
    kill $(pidof newsboat);
    # check inside tmux environment
    [ -n "${TMUX}" ] && tmux new-window newsboat
    if [ $? -ne 0 ]; then
        exec newsboat && break
    else
        break
    fi
done
