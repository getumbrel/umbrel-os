#!/bin/bash -e
set -x

uname -m

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


# echo "Pulling images in docker"
# while IFS= read -r image; do
#     docker pull --platform=linux/arm/v7 $image
# done <<< "$IMAGES"
docker pull --platform=linux/arm/v7 alpine:3.11
docker images -a

echo "Size of overlay 2 dir:"
du -sh /var/lib/docker/overlay2
tar -czvf ~/overlay2.tar.gz /var/lib/docker/overlay2
echo "Size of overlay 2 tar file:"
du -h ~/overlay2.tar.gz
# ls dockerpi
# ls dockerpi/var/lib/tor
# docker save $IMAGES -o umbrel-docker-images.tar
# du -h umbrel-docker-images.tar
# docker save $IMAGES | gzip > umbrel-docker-images.tar.gz 
# du -h umbrel-docker-images.tar.gz