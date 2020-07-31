#!/bin/bash -e

# Install docker via pip3 (within chroot)
echo "Installing docker-compose from pip3, and also setting up the box folder structure"

on_chroot << EOF
pip3 install docker-compose
cd /home/${FIRST_USER_NAME}
curl -L https://github.com/getumbrel/umbrel/archive/v${UMBREL_VERSION}.tar.gz | tar -xz --strip-components=1
chown -R ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}
EOF

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

echo "Copying the umbrel service to rootfs (etc/init.d)"
install -m 755 files/umbrel "${ROOTFS_DIR}"/etc/init.d/umbrel

echo "Pulling Docker images required to run Umbrel services"

wget -q "https://raw.githubusercontent.com/getumbrel/umbrel/v${UMBREL_VERSION}/docker-compose.yml"
IMAGES=$(grep '^\s*image' docker-compose.yml | sed 's/image://' | sed 's/\"//g' | sed '/^$/d;s/[[:blank:]]//g' | sort | uniq)
echo "List of images to download: $IMAGES"

while IFS= read -r image; do
    docker pull --platform=linux/arm64 $image
done <<< "$IMAGES"

mkdir -p ${ROOTFS_DIR}/var/lib/docker
rsync -qavPHSX /var/lib/docker ${ROOTFS_DIR}/var/lib/
