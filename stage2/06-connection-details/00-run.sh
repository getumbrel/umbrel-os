#!/bin/bash -e

echo "Installing connection-details and dependencies"

on_chroot pip3 install qrcode
chmod +x files/connection-details
cp files/connection-details ${ROOTFS_DIR}/usr/local/bin/connection-details
