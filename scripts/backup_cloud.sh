#!/bin/bash

set -e

# Sync chat logs
# Use parallel

LOG1="$HOME/.purple/logs/whatsapp/256782564488@s.whatsapp.net"
LOG2="$HOME/.purple/logs/whatsapp/256759879191@s.whatsapp.net"

rclone sync -LPMu --fast-list --transfers 40 --checkers 40 --tpslimit 10 --drive-chunk-size 1M --max-backlog 200000 --verbose --ignore-errors ~/linux-setup Mega:/linux-setup --exclude=/submodules/**

echo "Sync chat data..."
rclone copy -LPMu "$LOG1" Mega:/00.Data/256782564488@s.whatsapp.net && find "$LOG1" -type f -iregex '.*\.\(jpg\|txt\|png\|html\)$' | xargs rm -f
rclone copy -LPMu "$LOG2" Mega:/00.Data/256759879191@s.whatsapp.net && find "$LOG2" -type f -iname '*.jpg' | xargs rm -f

# Notify
notify-send "Sync done!"
