#!/bin/bash -e

apt-get update

install -m 755 files/resize2fs_once	"${ROOTFS_DIR}/etc/init.d/"

install -d				"${ROOTFS_DIR}/etc/systemd/system/rc-local.service.d"
install -m 644 files/ttyoutput.conf	"${ROOTFS_DIR}/etc/systemd/system/rc-local.service.d/"

install -m 644 files/50raspi		"${ROOTFS_DIR}/etc/apt/apt.conf.d/"

install -m 644 files/console-setup   	"${ROOTFS_DIR}/etc/default/"

install -m 755 files/rc.local		"${ROOTFS_DIR}/etc/"

# Maybe generate docker-compose file so we can use it
chmod 755 files/compose-service

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

# Install umbrelbox into runlevels
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

on_chroot << EOF
systemctl disable hwclock.sh
systemctl disable nfs-common
systemctl disable rpcbind
if [ "${ENABLE_SSH}" == "1" ]; then
	systemctl enable ssh
else
	systemctl disable ssh
fi
systemctl enable regenerate_ssh_host_keys
EOF

if [ ! -d $ROOTFS_DIR/home/statuses ]; then
    echo "Making a directory called 'statuses' for storing statuses of services"
    mkdir $ROOTFS_DIR/home/statuses
fi

if [ ! -z ${GITHUB_USERNAME} ]; then
    echo "Setting up authorized_keys file"
    mkdir -p $ROOTFS_DIR/home/$FIRST_USER_NAME
    cd $ROOTFS_DIR/home/$FIRST_USER_NAME
    echo "Making .ssh directory"
    mkdir -p .ssh
    cd .ssh
    echo "Fetching from github the ssh keys"
    curl "https://github.com/${GITHUB_USERNAME}.keys" > authorized_keys
fi

if [ "${USE_QEMU}" = "1" ]; then
	echo "enter QEMU mode"
	install -m 644 files/90-qemu.rules "${ROOTFS_DIR}/etc/udev/rules.d/"
	on_chroot << EOF
systemctl disable resize2fs_once
EOF
	echo "leaving QEMU mode"
else
	on_chroot << EOF
systemctl enable resize2fs_once
EOF
fi

on_chroot <<EOF
for GRP in input spi i2c gpio; do
	groupadd -f -r "\$GRP"
done
for GRP in adm dialout cdrom audio users sudo video games plugdev input gpio spi i2c netdev; do
  adduser $FIRST_USER_NAME \$GRP
done
EOF

on_chroot << EOF
setupcon --force --save-only -v
EOF

on_chroot << EOF
usermod --pass='*' root
EOF

rm -f "${ROOTFS_DIR}/etc/ssh/"ssh_host_*_key*
