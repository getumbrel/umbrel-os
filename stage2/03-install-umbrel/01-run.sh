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

# Bind Avahi to eth0,wlan0 interfaces to prevent hostname cycling
# https://github.com/getumbrel/umbrel-os/issues/76
echo "Binding Avahi to eth0 and wlan0 interfaces..."
on_chroot << EOF
sed -i "s/#allow-interfaces=eth0/allow-interfaces=eth0,wlan0/g;" "/etc/avahi/avahi-daemon.conf";
EOF

# Install Umbrel
echo "Installing Umbrel..."
echo

# Download Umbrel
mkdir /umbrel
cd /umbrel
if [ -z ${UMBREL_REPO} ]; then
curl -L https://github.com/getumbrel/umbrel/archive/v${UMBREL_VERSION}.tar.gz | tar -xz --strip-components=1
else
git clone ${UMBREL_REPO} .
git checkout "${UMBREL_BRANCH}"
fi

# Enable Umbrel OS systemd services
cd scripts/umbrel-os/services
UMBREL_SYSTEMD_SERVICES=$(ls *.service)
echo "Enabling Umbrel systemd services: ${UMBREL_SYSTEMD_SERVICES}"
for service in $UMBREL_SYSTEMD_SERVICES; do
    sed -i -e "s/\/home\/umbrel/\/home\/${FIRST_USER_NAME}/g" "${service}"
    install -m 644 "${service}"   "${ROOTFS_DIR}/etc/systemd/system/${service}"
    on_chroot << EOF
systemctl enable "${service}"
EOF
done

# Replace /home/umbrel with home/$FIRST_USER_NAME in other scripts
sed -i -e "s/\/home\/umbrel/\/home\/${FIRST_USER_NAME}/g" "/umbrel/scripts/umbrel-os/umbrel-details"

# Copy Umbrel to image
mkdir "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/umbrel"
rsync --quiet --archive --partial --hard-links --sparse --xattrs /umbrel "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/"

# Fix permissions
on_chroot << EOF
chown -R ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}/umbrel/
EOF

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
rsync --quiet --archive --partial --hard-links --sparse --xattrs /var/lib/docker ${ROOTFS_DIR}/var/lib/
