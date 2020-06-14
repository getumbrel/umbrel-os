#!/bin/bash -e

echo "Installing mender"

on_chroot << EOF
wget -q https://d1b0l86ne08fsf.cloudfront.net/2.3.0b1/dist-packages/debian/armhf/mender-client_2.3.0b1-1_armhf.deb
DEBIAN_FRONTEND=noninteractive dpkg -i mender-client_2.3.0b1-1_armhf.deb
EOF

echo "Installed mender, now setting it up"

on_chroot << EOF
mender setup --device-type "raspberrypi4" --server-ip "54.159.58.48" --demo
EOF