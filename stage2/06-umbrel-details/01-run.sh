#!/bin/bash -e

echo "Installing umbrel-details"
install -m 755 files/umbrel-details "${ROOTFS_DIR}"/usr/local/bin/umbrel-details
