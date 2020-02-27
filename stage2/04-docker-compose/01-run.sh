# Install docker via pip3 (within chroot)

on_chroot << EOF
pip3 install docker-compose
EOF

# Maybe generate docker-compose file so we can use it
chmod 644 files/docker-compose.yml
chmod 755 files/compose-service

cp files/docker-compose.yml   ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/docker-compose.yml
cp files/umbrel-createwallet.py ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/umbrel-createwallet.py
cp files/umbrel-unlock.py ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/umbrel-unlock.py

# Docker compose service
mkdir -p ${ROOTFS_DIR}/etc/init.d
mkdir -p ${ROOTFS_DIR}/etc/rc2.d
cp files/compose-service ${ROOTFS_DIR}/etc/init.d
# Run in chroot
on_chroot << EOF
cd /etc/rc2.d
ln -s /etc/init.d/compose-service S01composeservice
EOF

echo "Docker stuff installed" >> $ROOTFS_DIR/home/$FIRST_USER_NAME/docker-compose.txt


