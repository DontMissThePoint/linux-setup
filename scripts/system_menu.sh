#!/bin/bash
ACTION=$( echo "lock
shutdown
reboot
logout
suspend
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
