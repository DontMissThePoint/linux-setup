#!/bin/sh

GREEN='\033[0;32m'
NC='\033[0m' # No Color

# read -p "Username: " username
# win11
echo "${RED} 󰯄 [ Login credentials ]${NC}"
username=Quickemu
echo Username: "$username"
stty -echo
read -p "Password: " password
echo
stty echo

# deamon
cd ~/VirtualMachines/Windows-Docker
docker compose up -d

# Docker container
until /opt/freerdp-nightly/bin/xfreerdp3 /f /u:"${username}" /p:"${password}" /v:"$(hostname -I | awk '{print $1}')" \
  /dynamic-resolution +decorations +fonts +aero +window-drag +multitransport +clipboard -grab-keyboard -glyph-cache \
  /floatbar:sticky:off /bpp:32 /audio-mode:0 /rfx /gfx:rfx /cache:codec::rfx /video /sec:tls /multimon /t:"Dockurr - Windows 11" \
  /tune:FreeRDP_HiDefRemoteApp:true,FreeRDP_GfxAVC444v2:true,FreeRDP_GfxH264:true /scale-desktop:135 /scale-device:100; do
  # retry
  echo "\n${GREEN} ✔ ${NC}Verified\n"
  sleep 1
done
