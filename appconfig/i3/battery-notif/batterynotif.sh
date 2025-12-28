#!/bin/sh

# Using a PID file

cd "$(dirname "$0")"
PIDFILE=/tmp/$(basename "$0" .sh).pid

if [ -f "$PIDFILE" ]; then
    if [ -e /proc/"$(cat "$PIDFILE")" ]; then
        exit 0
    fi
fi
echo "$BASHPID" > "$PIDFILE"

# Making a function for each Notification type

notify_me_full () {
    notify-send -u critical -t 0 -i "$GIT_PATH/linux-setup/miscellaneous/icons/battery-full-charging.svg" "$1" "Level : $2%"
    paplay "$GIT_PATH"/linux-setup/miscellaneous/notifications/ac_notification.mp3
}

notify_me_low () {
    notify-send -u critical -t 0 -i "$GIT_PATH/linux-setup/miscellaneous/icons/battery-low.svg" "$1" "Level : $2%"
    paplay "$GIT_PATH"/linux-setup/miscellaneous/notifications/low_battery.mp3
}


while true
do
    export DISPLAY=:0.0
    battery_percent=$(cat /sys/class/power_supply/BAT0/capacity)
    if on_ac_power; then
        if [ "$battery_percent" -gt 96 ]; then
            notify_me_full "You can unplug the charger now! the battery is almost full" "$battery_percent"
        fi
    elif [ "$battery_percent" -lt 20 ]; then
        notify_me_low "Plug the charger. Battery level is low, and that's not good" "$battery_percent"
    fi
    sleep 240 # 4 minutes
done
