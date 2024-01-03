#!/bin/bash
# Sync chat logs
# Use parallel

LOG1="$HOME/.purple/logs/whatsapp/256782564488@s.whatsapp.net"
LOG2="$HOME/.purple/logs/whatsapp/256759879191@s.whatsapp.net"

sudo rclone sync -LPMu ~/linux-setup Mega:/linux-setup

echo "Sync chat data..."
sudo rclone copy -LPMu "$LOG1" Mega:/00.Data/256782564488@s.whatsapp.net && find "$LOG1" -type f -iregex '.*\.\(jpg\|txt\|png\|html\)$' | xargs rm -f
sudo rclone copy -LPMu "$LOG2" Mega:/00.Data/256759879191@s.whatsapp.net && find "$LOG2" -type f -iname '*.jpg' | xargs rm -f

# Notify
notify-send "Sync done!"
