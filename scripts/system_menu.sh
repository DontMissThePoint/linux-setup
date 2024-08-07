#!/bin/bash
ACTION=$( echo "lock
shutdown
reboot
logout
suspend
hibernate" | rofi -dmenu -p "Select desired action:")

case "$ACTION" in
    lock)
        betterlockscreen -q -l dimpixel  # i3lock-fancy --pixelate
        ;;
    logout)
        i3-msg exit
        ;;
    suspend)
        i3lock -kf -i $GIT_PATH/linux-setup/miscellaneous/wallpapers/space.jpg -L && systemctl suspend
        ;;
    hibernate)
        i3lock && systemctl hibernate
        ;;
    reboot)
        systemctl reboot
        ;;
    shutdown)
        systemctl poweroff
        ;;
    *)
esac
