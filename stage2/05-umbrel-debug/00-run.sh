#!/bin/bash -e

echo "Installing umbrel-debug"

install -m 755 files/umbrel-debug "${ROOTFS_DIR}"/usr/bin/umbrel-debug
sed -i -e "s/\/home\/umbrel/\/home\/${FIRST_USER_NAME}/g" "${ROOTFS_DIR}"/usr/bin/umbrel-debug
