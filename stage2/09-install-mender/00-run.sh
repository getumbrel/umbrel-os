#!/bin/bash -e

echo "Installing mender"

on_chroot << EOF
wget -q ttps://d1b0l86ne08fsf.cloudfront.net/2.3.0b1/dist-packages/debian/armhf/mender-client_2.3.0b1-1_armhf.deb
DEBIAN_FRONTEND=noninteractive dpkg -i mender-client_2.3.0b1-1_armhf.deb
EOF