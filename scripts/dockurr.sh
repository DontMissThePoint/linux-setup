#!/bin/sh

# read -p "Username: " username
# win11
username=Quickemu
echo Username: "$username"
stty -echo
read -p "Password: " password; echo
stty echo

# Start windows inside Docker container
# guest DPI text : 125
# desktop scale factor. This value MUST be ignored if it is less than 100%
# or greater than 500% or deviceScaleFactor is not 100%, 140%, or 180%.
/opt/freerdp-nightly/bin/xfreerdp3 /f /u:"${username}" /p:"${password}" /v:"$(hostname -I | awk '{print $1}')" /dynamic-resolution +decorations +fonts +aero +window-drag +multitransport +clipboard /floatbar:sticky:off /bpp:32 /audio-mode:0 /rfx /gfx:rfx /codec-cache:rfx /video /tune:FreeRDP_HiDefRemoteApp:true,FreeRDP_GfxAVC444v2:true,FreeRDP_GfxH264:true /scale-desktop:135 /scale-device:100
