#!/bin/bash -e

# Install docker via pip3 (within chroot)
echo "Installing docker-compose from pip3, and also setting up the box folder structure"

on_chroot << EOF
pip3 install docker-compose
cd /home/${FIRST_USER_NAME}
git init
git remote add origin https://github.com/mayankchhabra/umbrel.git
git fetch --all --tags
git checkout patch/cors
git reset --hard patch/cors
rm -fr .git
rm -fr README.md
rm -fr NETWORKING.md
rm -fr CONTRIBUTING.md
rm -fr LICENSE
rm -fr install-box.sh
chown -R ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}
EOF

# Maybe generate docker-compose file so we can use it
chmod 755 files/umbrel

# Umbrel service
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
cp files/umbrel ${ROOTFS_DIR}/etc/init.d/umbrel


echo "Pulling Docker images required to run Umbrel services"

wget -q "https://raw.githubusercontent.com/getumbrel/umbrel/v${UMBREL_VERSION}/docker-compose.yml"
IMAGES=$(grep '^\s*image' docker-compose.yml | sed 's/image://' | sed 's/\"//g' | sed '/^$/d;s/[[:blank:]]//g' | sort | uniq)
echo "List of images to download: $IMAGES"

while IFS= read -r image; do
    docker pull --platform=linux/arm/v7 $image
done <<< "$IMAGES"

mkdir -p ${ROOTFS_DIR}/var/lib/docker
rsync -avPHSX /var/lib/docker ${ROOTFS_DIR}/var/lib/