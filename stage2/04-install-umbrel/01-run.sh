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
on_chroot << EOF
mkdir /home/${FIRST_USER_NAME}/umbrel
cd /home/${FIRST_USER_NAME}/umbrel
curl -L https://github.com/getumbrel/umbrel/archive/v${UMBREL_VERSION}.tar.gz | tar -xz --strip-components=1
chown -R ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}
sed -i -e "s/\/home\/umbrel/\/home\/${FIRST_USER_NAME}/g" scripts/umbrel-os/umbrel-details
sed -i -e "s/\/home\/umbrel/\/home\/${FIRST_USER_NAME}/g" scripts/umbrel-os/services/umbrel-connection-details.service
EOF

# Bundle Umbrel's Docker images
echo "Pulling Umbrel's Docker images..."
echo
wget -q "https://raw.githubusercontent.com/getumbrel/umbrel/v${UMBREL_VERSION}/docker-compose.yml"
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
