#!/bin/bash -e

echo "Installing connection-details"

chmod +x files/connection-details
cp files/connection-details "${ROOTFS_DIR}"/usr/local/bin/connection-details
