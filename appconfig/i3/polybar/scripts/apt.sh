#!/bin/bash

if ! updates_brew=$(brew outdated 2> /dev/null | wc -l ); then
    updates_brew=0
fi

if ! updates_apt=$(apt list --upgradable 2> /dev/null | wc -l); then
    updates_apt=0
fi

updates=$((updates_brew + updates_apt))

if [ "$updates" -gt 0 ]; then
    echo "# $updates"
else
    echo ""
fi
