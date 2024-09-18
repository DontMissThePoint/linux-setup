#!/bin/bash

if [ $1 == "play" ]; then
echo "Playing... from mpv playlist"
    mpv --playlist=/tmp/playlist --input-ipc-server=/tmp/mpvsocket
    rm -f /tmp/playlist
fi


if [ $1 == "push" ]; then
    echo $2 >> /tmp/playlist
fi
