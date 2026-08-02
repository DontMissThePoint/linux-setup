#!/bin/bash

CONTAINER_NAME="WinBoat"

# container
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    # deamon
    cd ~/.winboat
    docker compose up -d
fi
RDP_PORT=$(docker inspect --format='{{(index (index .NetworkSettings.Ports "3389/tcp") 0).HostPort}}' "$CONTAINER_NAME")

# display
until
xfreerdp3 /u:Dockurr /p:win11 /v:127.0.0.1 /port:"$RDP_PORT" /cert:ignore /clipboard /sound:sys:pulse /microphone:sys:pulse \
    /floatbar:sticky:off /compression /scale:140 /scale-desktop:112 /wm-class:xfreerdp /gdi:hw /f \
    -grab-keyboard +auto-reconnect +async-channels +async-update /t:"Dockurr - Windows 11"

do

    sleep 1

    # app
    echo "Windows started..."
done

# powershell
# Get-AppxPackage -Name *PowerBIDesktop* | Select-Object InstallLocation
