# Install docker via pip3 (within chroot)

echo "Installing docker-compose from pip3, and also setting up the box folder structure"

on_chroot << EOF
pip3 install docker-compose
cd /home/${FIRST_USER_NAME}
wget -qO- "https://raw.githubusercontent.com/getumbrel/umbrel-compose/master/install-box.sh" | sh
chown -R ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}
EOF

# Maybe generate docker-compose file so we can use it
chmod 755 files/compose-service

# These can be probabably removed
cp files/umbrel-createwallet.py ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/umbrel-createwallet.py
cp files/umbrel-unlock.py ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/umbrel-unlock.py

# Docker compose service
on_chroot << EOF
mkdir -p /etc/init.d
mkdir -p /etc/rc2.d
mkdir -p /etc/rc3.d
mkdir -p /etc/rc4.d
mkdir -p /etc/rc5.d
mkdir -p /etc/rc0.d
mkdir -p /etc/rc1.d
mkdir -p /etc/rc6.d
EOF

echo "Copying the compose service to rootfs (etc/init.d)"
cp files/compose-service ${ROOTFS_DIR}/etc/init.d/umbrelbox

on_chroot << EOF
cd /etc/rc2.d
ln -s /etc/init.d/umbrelbox S01umbrelbox
cd /etc/rc3.d
ln -s /etc/init.d/umbrelbox S01umbrelbox
cd /etc/rc4.d
ln -s /etc/init.d/umbrelbox S01umbrelbox
cd /etc/rc5.d
ln -s /etc/init.d/umbrelbox S01umbrelbox
cd /etc/rc0.d
ln -s /etc/init.d/umbrelbox K01umbrelbox
cd /etc/rc1.d
ln -s /etc/init.d/umbrelbox K01umbrelbox
cd /etc/rc6.d
ln -s /etc/init.d/umbrelbox K01umbrelbox
EOF

echo "Docker stuff installed!"

