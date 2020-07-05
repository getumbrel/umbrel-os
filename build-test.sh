#!/bin/bash -e
set -x

uname -m
# sudo apt-get install qemu binfmt-support qemu-user-static # Install the qemu packages
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes # This step will execute the registering scripts

mkdir docker-dir
docker run --rm -d --name dockerdebian -v docker-dir:/var/lib/docker multiarch/debian-debootstrap:armhf-buster-slim bash
docker ps
docker exec -t dockerdebian uname -m

# wget -q "https://raw.githubusercontent.com/getumbrel/umbrel-compose/master/docker-compose.yml"
# IMAGES=$(grep '^\s*image' docker-compose.yml | sed 's/image://' | sed 's/\"//g' | sed '/^$/d;s/[[:blank:]]//g' | sort | uniq)
# echo "List of images to download: $IMAGES"

# mkdir dockerpi
# echo "Running Docker Pi"
# docker run --name dockerpi -v dockerpi:/sdcard lukechilds/dockerpi 
# docker ps
# echo "Downloading install script"
# docker exec -d dockerpi curl -fsSL https://get.docker.com -o docker-install.sh
# echo "Running install script"
# docker exec -d dockerpi ./docker-install.sh
# echo "Pulling images in docker"
# while IFS= read -r image; do
#     docker exec -d docker pull --platform=linux/arm/v7 $image
# done <<< "$IMAGES"
# ls dockerpi
# ls dockerpi/var/lib/tor
# docker save $IMAGES -o umbrel-docker-images.tar
# du -h umbrel-docker-images.tar
# docker save $IMAGES | gzip > umbrel-docker-images.tar.gz 
# du -h umbrel-docker-images.tar.gz