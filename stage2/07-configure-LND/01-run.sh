chmod 644 files/lnd.conf
mkdir ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/lnd
cp files/lnd.conf   ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/lnd/lnd.conf

