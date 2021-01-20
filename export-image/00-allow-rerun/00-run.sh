#!/bin/bash -e

if [ ! -x "${ROOTFS_DIR}/usr/bin/qemu-aarch64-static" ]; then
	cp /usr/bin/qemu-aarch64-static "${ROOTFS_DIR}/usr/bin/"
fi
