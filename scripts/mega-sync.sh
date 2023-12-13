#!/bin/bash
# Last change : Wed 02 Aug 2023 11:29:26 AM EAT
# Use parallel

rclone sync -iLPu ~/linux-setup Mega:/linux-setup
rclone copy -LPu ~/.purple/logs/whatsapp/256782564488@s.whatsapp.net Mega:/Data/256782564488@s.whatsapp.net
rclone copy -LPu ~/.purple/logs/whatsapp/256759879191@s.whatsapp.net Mega:/Data/256759879191@s.whatsapp.net

# Notify
notify-send "Sync done!"
