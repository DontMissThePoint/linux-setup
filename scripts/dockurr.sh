#!/bin/sh

# echo -n "Username: "
# read username
username=Quickemu
read -p "Password: " password

# Start windows inside Docker container
/opt/freerdp-nightly/bin/xfreerdp3 /f /u:"${username}" /p:"${password}" /v:"$(hostname -I | awk '{print $1}')" /dynamic-resolution +decorations +fonts +aero +window-drag +multitransport +clipboard /floatbar:sticky:off /bpp:32 /audio-mode:0 /rfx /gfx:rfx /codec-cache:rfx /video /tune:FreeRDP_HiDefRemoteApp:true,FreeRDP_GfxAVC444v2:true,FreeRDP_GfxH264:true /scale-desktop:146 /scale-device:140
