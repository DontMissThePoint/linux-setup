#!/bin/bash

# battery notifications
LOW_THRESHOLD=20
CRITICAL_THRESHOLD=11
CHARGED_THRESHOLD=95

# percentage and charging status
BATTERY_PERCENTAGE=$(acpi -b | grep -P -o '[0-9]+(?=%)')
AC_POWER=$(acpi -b | grep -c "Full")

# Function to send a notification
send_notification() {
    local title="$1"
    local message="$2"
    local icon="$3"
    /usr/bin/dunstify -t  5000 -u critical -i "$icon" "$title" "$message"
}

# Check battery status and send notifications
if [[ $BATTERY_PERCENTAGE -ge $CHARGED_THRESHOLD ]] && [[ $AC_POWER -eq 1 ]];
then
  send_notification "Battery Fully Charged" "Your battery is fully charged." "battery-full" && mpg123 \
    /home/$USER/linux-setup/miscellaneous/notifications/notificacioncool.mp3
  elif [[ $BATTERY_PERCENTAGE -le $LOW_THRESHOLD ]] && [[ $AC_POWER -eq 0 ]];
  then
    send_notification "Low Battery" "Your battery is below $LOW_THRESHOLD%. Please connect charger." "battery-caution" && mpg123 \
      /home/$USER/linux-setup/miscellaneous/notifications/low_battery.mp3
    elif [[ $BATTERY_PERCENTAGE -le $CRITICAL_THRESHOLD ]] && [[ $AC_POWER -eq 0 ]];
    then
      send_notification "Critical Battery" "Your battery is critically low! Connect charger immediately!" "battery-alert"
fi
