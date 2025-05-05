#!/bin/bash
ACTION=$( echo "lock
shutdown
reboot
logout
suspend
hibernate" | rofi -dmenu -p "Select desired action:")

case "$ACTION" in
    lock)
         betterlockscreen -q -l dimpixel
        ;;
    logout)
        i3-msg exit
        ;;
    suspend)
        systemctl suspend && i3lock -L -i "$GIT_PATH/linux-setup/miscellaneous/wallpapers/falcon_heavy.jpg"
        ;;
    hibernate)
        systemctl suspend && i3lock -L -i "$GIT_PATH/linux-setup/miscellaneous/wallpapers/falcon_heavy.jpg"
        ;;
    reboot)
        systemctl reboot
        ;;
    shutdown)
        systemctl poweroff
        ;;
    *)
esac
