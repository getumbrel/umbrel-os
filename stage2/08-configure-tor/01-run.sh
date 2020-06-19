# TODO: configure username and password (internally)

chmod 644 files/torrc
mkdir -p ${ROOTFS_DIR}/etc/tor/
echo "Overriding TORRC"
cp files/torrc   ${ROOTFS_DIR}/etc/tor/torrc
