# TODO: configure username and password (internally)

echo "Downloading password utility"
cd ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/bin
curl "https://raw.githubusercontent.com/bitcoin/bitcoin/master/share/rpcauth/rpcauth.py" 2>/dev/null 1>rpcauth.py
chmod 755 rpcauth.py

on_chroot << EOF
chown -R ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}
EOF
