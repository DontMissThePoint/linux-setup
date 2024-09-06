#!/bin/sh

RESTIC_PASSWORD_FILE=$GIT_PATH/linux-setup/appconfig/rclone/restic.txt

# restic init --repo --password-file=$GIT_PATH/linux-setup/appconfig/rclone/restic.txt /media/$USER/Envy/00-09.Library/07.OS
restic -r /media/$USER/Envy/00-09.Library/07.OS --verbose backup $GIT_PATH/linux-setup
