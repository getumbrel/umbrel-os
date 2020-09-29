#!/bin/bash -e

install -m 644 files/armstub8-gic-spectrev4.bin "${ROOTFS_DIR}/boot/"
echo "
armstub=armstub8-gic-spectrev4.bin" >> "${ROOTFS_DIR}/boot/config.txt"
