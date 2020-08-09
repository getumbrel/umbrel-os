#!/bin/bash -e

# Install docker via pip3 (within chroot)
echo "Installing docker-compose from pip3, and also setting up the box folder structure"

on_chroot << EOF
pip3 install docker-compose
mkdir /home/${FIRST_USER_NAME}/umbrel
cd /home/${FIRST_USER_NAME}/umbrel
git clone https://github.com/getumbrel/umbrel.git .
chown -R ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}
EOF

echo "Pulling Docker images required to run Umbrel services"

wget -q "https://raw.githubusercontent.com/getumbrel/umbrel/v${UMBREL_VERSION}/docker-compose.yml"
IMAGES=$(grep '^\s*image' docker-compose.yml | sed 's/image://' | sed 's/\"//g' | sed '/^$/d;s/[[:blank:]]//g' | sort | uniq)
echo "List of images to download: $IMAGES"

while IFS= read -r image; do
    docker pull --platform=linux/arm64 $image
done <<< "$IMAGES"

mkdir -p ${ROOTFS_DIR}/var/lib/docker
rsync -qavPHSX /var/lib/docker ${ROOTFS_DIR}/var/lib/
