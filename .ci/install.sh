#!/bin/bash

set -e

distro=$(. /etc/os-release && echo "$UBUNTU_CODENAME")
[ "$distro" = "noble" ] && ROS_DISTRO="jazzy"

sudo apt-get -y install git

echo "running the main install.sh"

./install.sh --unattended

echo "install part ended"
