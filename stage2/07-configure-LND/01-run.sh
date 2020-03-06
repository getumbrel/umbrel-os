chmod 644 files/lnd.conf
echo "Copying lnd.conf to overwrite the existing LND.conf"
cp files/lnd.conf   ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/lnd/lnd.conf
on_chroot << EOF
chown -R ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}
EOF
