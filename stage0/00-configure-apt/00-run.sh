#!/bin/bash -e

install -m 644 files/sources.list "${ROOTFS_DIR}/etc/apt/"
install -m 644 files/raspi.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"

if [ -n "$APT_PROXY" ]; then
	install -m 644 files/51cache "${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache"
	sed "${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache" -i -e "s|APT_PROXY|${APT_PROXY}|"
else
	rm -f "${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache"
fi

on_chroot apt-key add - < files/raspberrypi.gpg.key
on_chroot << EOF
apt-get update
apt-get dist-upgrade -y
EOF

echo "Installing Go"
go version
echo "Go installed, now downloading images"

wget -q "https://raw.githubusercontent.com/moby/moby/master/contrib/download-frozen-image-v2.sh"
chmod +x download-frozen-image-v2.sh
./download-frozen-image-v2.sh docker-images getumbrel/middleware:latest
ls docker-images/
cp -avr docker-images/ ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/docker-images

on_chroot << EOF
ls /home/${FIRST_USER_NAME}/
ls /home/${FIRST_USER_NAME}/docker-images
EOF