# TODO: configure username and password (internally)

chmod 644 files/bitcoin.conf
mkdir ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/bitcoin
cp files/bitcoin.conf   ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/bitcoin/bitcoin.conf

echo "Downloading password utility"
cd ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/bin
curl "https://raw.githubusercontent.com/bitcoin/bitcoin/master/share/rpcauth/rpcauth.py" 2>/dev/null 1>rpcauth.py
chmod 755 rpcauth.py
