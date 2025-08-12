#!/bin/bash

# report
DIR="$HOME/Journal"
[ ! -e "$DIR" ] && mkdir -p "$DIR"

# bandwidth
vnstat -hg >"$DIR"/bandwidth.txt
vnstati -vs -o "$DIR"/bandwidth.png
