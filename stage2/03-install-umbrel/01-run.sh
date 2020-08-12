#!/bin/bash -e

# This script:
# - Installs Umbrel's dependencies
# - Installs Umbrel

# Install Docker
echo "Installing Docker..."
echo
on_chroot << EOF
curl -fsSL https://get.docker.com | sh
usermod -a -G docker $FIRST_USER_NAME
EOF

# Install Docker Compose with pip3
echo "Installing Docker Compose..."
echo
on_chroot << EOF
pip3 install docker-compose
EOF

# Install Umbrel
echo "Installing Umbrel..."
echo

mkdir /umbrel
cd /umbrel
curl -L https://github.com/getumbrel/umbrel/archive/v${UMBREL_VERSION}.tar.gz | tar -xz --strip-components=1
echo "Debugging dir:"
ls 
cd /scripts/umbrel-os/services
echo "Debugging services:"
ls
UMBREL_SYSTEMD_SERVICES=$(ls *.service)
echo "Services:"
echo $UMBREL_SYSTEMD_SERVICES
for service in $UMBREL_SYSTEMD_SERVICES; do
    echo "Replacing /home/umbrel in ${service} with /home/${FIRST_USER_NAME}"
    sed -i -e "s/\/home\/umbrel/\/home\/${FIRST_USER_NAME}/g" "${service}"
    echo "Installing  ${service} at ${ROOTFS_DIR}/etc/systemd/system/${service}"
    install -m 644 "${service}"   "${ROOTFS_DIR}/etc/systemd/system/${service}"
    echo "Enabling ${service}"
    on_chroot << EOF
systemctl enable "${service}"
EOF
done

echo "Creating ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/umbrel"
mkdir "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/umbrel"

echo "Copying /umbrel to ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/umbrel"
rsync -avPHSX /umbrel "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/"

echo "Debugging ROOTFS home"
ls ${ROOTFS_DIR}/home/${FIRST_USER_NAME}
echo "Debugging ROOTFS umbrel"
ls ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/umbrel
echo "Debugging ROOTFS systemd"
ls ${ROOTFS_DIR}/etc/systemd/system/

# Bundle Umbrel's Docker images
echo "Pulling Umbrel's Docker images..."
echo
cd /umbrel
IMAGES=$(grep '^\s*image' docker-compose.yml | sed 's/image://' | sed 's/\"//g' | sed '/^$/d;s/[[:blank:]]//g' | sort | uniq)
echo
echo "Images to bundle: $IMAGES"
echo

while IFS= read -r image; do
    docker pull --platform=linux/arm64 $image
done <<< "$IMAGES"

# Copy the entire /var/lib/docker directory to image
mkdir -p ${ROOTFS_DIR}/var/lib/docker
rsync -qavPHSX /var/lib/docker ${ROOTFS_DIR}/var/lib/
