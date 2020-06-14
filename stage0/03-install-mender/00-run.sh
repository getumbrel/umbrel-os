#!/bin/bash -e

echo "Installing Mender"

on_chroot << EOF
wget -q ttps://d1b0l86ne08fsf.cloudfront.net/2.3.0b1/dist-packages/debian/armhf/mender-client_2.3.0b1-1_armhf.deb

DEVICE_TYPE="raspberrypi4"
SERVER_IP_ADDR="54.159.58.48"
DEBIAN_FRONTEND=noninteractive dpkg -i mender-client_2.3.0b1-1_armhf.deb
mender setup \
        --device-type $DEVICE_TYPE \
        --demo \
        --server-ip $SERVER_IP_ADDR
EOF