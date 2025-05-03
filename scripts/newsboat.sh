#!/bin/bash

while true; do
    # Terminate already running boat instances
    killall -q newsboat

    # Wait until the processes have been shut down
    while pgrep -u $UID -x newsboat >/dev/null; do sleep 1; done

    # check inside tmux environment
    [ -n "${TMUX}" ] && tmux new-window newsboat
    if [ $? -ne 0 ]; then
        exec newsboat && break 2 &> /dev/null
    else
        break
    fi
done
