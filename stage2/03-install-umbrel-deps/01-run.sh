#!/bin/bash -e

# This script:
# - Installs Umbrel's dependencies
# - Installs Umbrel

# Install Docker
echo "Installing Docker..."
echo
on_chroot << EOF
curl -fsSL https://get.docker.com | sh
usermod -a -G docker $FIRST_USER_NAME
EOF

# Install Docker Compose with pip3
echo "Installing Docker Compose..."
echo
on_chroot << EOF
pip3 install docker-compose
EOF

# Bind Avahi to eth0,wlan0 interfaces to prevent hostname cycling
# https://github.com/getumbrel/umbrel-os/issues/76
echo "Binding Avahi to eth0 and wlan0 interfaces..."
on_chroot << EOF
sed -i "s/#allow-interfaces=eth0/allow-interfaces=eth0,wlan0/g;" "/etc/avahi/avahi-daemon.conf";
EOF