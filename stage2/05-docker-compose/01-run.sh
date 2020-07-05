#!/bin/bash -e

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


echo "Docker stuff installed!"

echo "Bundling Docker images required to run Umbrel services"

echo "Removing Docker"
docker ps
docker images -a
du -sh /var/lib/docker/overlay2
sudo systemctl stop docker
sudo apt-get purge docker-ce docker-ce-cli containerd.io moby-engine moby-cli
sudo rm -rf /var/lib/docker

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
docker --version
docker ps
docker images -a
sudo rm -rf /etc/docker/daemon.json
echo '{"experimental": true}' | sudo tee -a /etc/docker/daemon.json


wget -q "https://raw.githubusercontent.com/getumbrel/umbrel-compose/master/docker-compose.yml"
IMAGES=$(grep '^\s*image' docker-compose.yml | sed 's/image://' | sed 's/\"//g' | sed '/^$/d;s/[[:blank:]]//g' | sort | uniq)
echo "List of images to download: $IMAGES"

while IFS= read -r image; do
    docker pull --platform=linux/arm/v7 $image
done <<< "$IMAGES"

# docker save $IMAGES | gzip > umbrel-docker-images.tar.gz
# du -h umbrel-docker-images.tar.gz
rsync -avPHSX /var/lib/docker/overlay2 ${ROOTFS_DIR}/var/lib/docker/overlay2/
# cp umbrel-docker-images.tar.gz ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/umbrel-docker-images.tar.gz