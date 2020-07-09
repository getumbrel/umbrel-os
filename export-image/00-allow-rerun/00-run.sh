#!/bin/bash -e

if [ ! -x "${ROOTFS_DIR}/usr/bin/qemu-aarch64-static" ]; then
	cp /usr/bin/qemu-aarch64-static "${ROOTFS_DIR}/usr/bin/"
fi

if [ -e "${ROOTFS_DIR}/etc/ld.so.preload" ]; then
	mv "${ROOTFS_DIR}/etc/ld.so.preload" "${ROOTFS_DIR}/etc/ld.so.preload.disabled"
fi
