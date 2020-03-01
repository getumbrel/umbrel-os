# TODO: configure username and password (internally)

chmod 644 files/bitcoin.conf
mkdir ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/bitcoin
cp files/bitcoin.conf   ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/bitcoin/bitcoin.conf

