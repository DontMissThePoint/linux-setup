#!/bin/bash
ACTION=$( echo "suspend
shutdown
reboot
lock
logout
hibernate" | rofi -dmenu -p "Select desired action:")

case "$ACTION" in
    lock)
        "$(i3-msg exit)" & "$(xset dpms force off)"
        ;;
    logout)
        i3-msg exit
        ;;
    suspend)
        "$(systemctl suspend)"
        ;;
    hibernate)
        "$(systemctl suspend)"
        ;;
    reboot)
        systemctl reboot
        ;;
    shutdown)
        systemctl poweroff
        ;;
    *)
;; esac
