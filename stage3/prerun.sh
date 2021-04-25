#!/bin/bash -e

apt-get update

if [ ! -d "${ROOTFS_DIR}" ]; then
	copy_previous
fi
