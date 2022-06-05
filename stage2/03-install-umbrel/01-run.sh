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

echo "Install yq..."
# Download yq from GitHub
yq_temp_file="/tmp/yq"
curl -L "https://github.com/mikefarah/yq/releases/download/v4.24.5/yq_linux_arm64" -o "${yq_temp_file}"

# Check file matches checksum
if [[ "$(sha256sum "${yq_temp_file}" | awk '{ print $1 }')" == "8879e61c0b3b70908160535ea358ec67989ac4435435510e1fcb2eda5d74a0e9" ]]; then
    sudo mv "${yq_temp_file}" "${ROOTFS_DIR}/usr/bin/yq"
    sudo chmod +x "${ROOTFS_DIR}/usr/bin/yq"
    echo "yq installed successfully..."
else
    echo "yq install failed. sha256sum mismatch"
    exit 1
fi

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
