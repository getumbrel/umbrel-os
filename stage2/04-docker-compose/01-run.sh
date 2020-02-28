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
mkdir -p ${ROOTFS_DIR}/etc/rc3.d
mkdir -p ${ROOTFS_DIR}/etc/rc4.d
mkdir -p ${ROOTFS_DIR}/etc/rc5.d
mkdir -p ${ROOTFS_DIR}/etc/rc0.d
mkdir -p ${ROOTFS_DIR}/etc/rc1.d
mkdir -p ${ROOTFS_DIR}/etc/rc6.d

echo "Copying the compose service to rootfs (etc/init.d)"
cp files/compose-service ${ROOTFS_DIR}/etc/init.d/umbrelbox
cp files/compose-service ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/umbrelbox

# Run in chroot
echo "Performing actions in chroot"
on_chroot << EOF
echo "Get whats in /etc/init.d"
ls /etc/init.d/
echo "Adding to defaults"
update-rc.d umbrelbox defaults

echo "Trying to enable service"
update-rc.d umbrelbox enable
EOF

echo "Docker stuff installed" >> $ROOTFS_DIR/home/$FIRST_USER_NAME/docker-compose.txt


