sed -i -e "s/UMBREL_OS=<version>/UMBREL_OS=$UMBREL_OS_VERSION/g" files/umbrel
install -m 644 files/umbrel "${ROOTFS_DIR}"/etc/default/umbrel
