#!/bin/bash -e

echo "Installing umbrel-debug"

install -m 755 files/umbrel-debug "${ROOTFS_DIR}"/usr/local/bin/umbrel-debug
sed -i -e "s/\/home\/umbrel/\/home\/${FIRST_USER_NAME}/g" /usr/local/bin/umbrel-debug
