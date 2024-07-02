#!/bin/sh

while true; do
    kill $(pidof newsboat);
    rm $XDG_CONFIG_HOME/newsboat/queue;
    # check inside tmux environment
    [ -n "${TMUX}" ] && tmux new-window newsboat
    if [ $? -ne 0 ]; then
        exec newsboat && break
    else
        break
    fi
done
