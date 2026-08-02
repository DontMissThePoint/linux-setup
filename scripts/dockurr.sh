#!/bin/bash

CONTAINER_NAME="WinBoat"
OPTIONS="Desktop\nExcel"
VAR=$(printf "$OPTIONS" | fzf --prompt="Select app: ")

# user
if [ "$VAR" = "" ]; then
    echo "Exiting..."
    exit 1
fi

# container
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    # deamon
    cd ~/.winboat
    docker compose up -d
fi
RDP_PORT=$(docker inspect --format='{{(index (index .NetworkSettings.Ports "3389/tcp") 0).HostPort}}' "$CONTAINER_NAME")

# /opt/freerdp-nightly/bin/xfreerdp3 /cert:tofu /f /u:"$username" /p:"$password" /v:"$(hostname -I | awk '{print $1}')" \
    #     /dynamic-resolution +decorations +fonts +aero +window-drag +multitransport +clipboard -grab-keyboard /cache:glyph:on \
    #     /floatbar:show:fullscreen /floatbar:sticky:off /bpp:32 /audio-mode:0 /gfx:avc444 /video /sec:tls -themes -wallpaper \
    #     /tune:FreeRDP_HiDefRemoteApp:true,FreeRDP_GfxAVC444v2:true,FreeRDP_GfxH264:true /scale-desktop:135 /scale-device:100 \
    #     /w:1080 /h:1920 /t:"Dockurr - Windows 11"

# connect
RDP_ARGS=(
    /u:Dockurr
    /p:win11
    /v:127.0.0.1
    /port:"$RDP_PORT"
    /cert:ignore
    /clipboard
    /sound:sys:pulse
    /microphone:sys:pulse
    /floatbar:sticky:off
    /compression
    /scale:100
    /scale-desktop:112
    /wm-class:xfreerdp
    /f
    -grab-keyboard
    +fonts
    +multitransport
)

# powershell
# Get-AppxPackage -Name *PowerBIDesktop* | Select-Object InstallLocation

until
case "$VAR" in
    "Excel")
        xfreerdp3 "${RDP_ARGS[@]}" /t:"Dockurr - Excel" \
            '/app:program:C:\\Program Files\\Microsoft Office\\root\\Office16\\EXCEL.EXE'
        ;;
    "PowerBI")
        xfreerdp3 "${RDP_ARGS[@]}" /t:"Dockurr - Power BI" \
            '/app:program:C:\\Program Files\\Microsoft Power BI Desktop\\bin\\PBIDesktop.exe'
        ;;
    "Desktop")
        # Launching the full desktop removes the remote app flags
        xfreerdp3 "${RDP_ARGS[@]}" /t:"Dockurr - Windows 11"
        ;;
    *)
        echo "App not installed."
        ;;
esac
do

    sleep 1

    # app
    echo "Starting $VAR..."
done
