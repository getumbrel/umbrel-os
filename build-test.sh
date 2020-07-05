#!/bin/bash -e
set -x

uname -m

echo "Removing Docker"
docker ps
docker --version
sudo apt-get purge docker-ce docker-ce-cli containerd.io moby-engine
sudo rm -rf /var/lib/docker

ls /var/lib

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
docker --version
docker ps

ls /var/lib


# wget -q "https://raw.githubusercontent.com/getumbrel/umbrel-compose/master/docker-compose.yml"
# IMAGES=$(grep '^\s*image' docker-compose.yml | sed 's/image://' | sed 's/\"//g' | sed '/^$/d;s/[[:blank:]]//g' | sort | uniq)
# echo "List of images to download: $IMAGES"


# echo "Pulling images in docker"
# while IFS= read -r image; do
#     docker run --rm -t -v docker-dir:/var/lib/docker docker:stable-dind docker pull --platform=linux/arm/v7 $image
# done <<< "$IMAGES"
# docker ps
# ls docker-dir

# ls dockerpi
# ls dockerpi/var/lib/tor
# docker save $IMAGES -o umbrel-docker-images.tar
# du -h umbrel-docker-images.tar
# docker save $IMAGES | gzip > umbrel-docker-images.tar.gz 
# du -h umbrel-docker-images.tar.gz