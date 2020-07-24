#!/bin/bash -e

echo "Installing connection-details"
install -m 755 files/connection-details "${ROOTFS_DIR}"/usr/local/bin/connection-details
