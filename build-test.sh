#!/bin/bash -e
set -x

wget -q "https://raw.githubusercontent.com/getumbrel/umbrel-compose/master/docker-compose.yml"
IMAGES=$(grep '^\s*image' docker-compose.yml | sed 's/image://' | sed 's/\"//g' | sed '/^$/d;s/[[:blank:]]//g' | sort | uniq)
echo "List of images to download: $IMAGES"

mkdir dockerpi
echo "Running Docker Pi"
docker run -v dockerpi:/sdcard lukechilds/dockerpi --name "dockerpi"
docker ps
echo "Downloading install script"
docker exec -i dockerpi curl -fsSL https://get.docker.com -o docker-install.sh
echo "Running install script"
docker exec -i dockerpi ./docker-install.sh
echo "Pulling images in docker"
while IFS= read -r image; do
    docker exec -i docker pull --platform=linux/arm/v7 $image
done <<< "$IMAGES"
ls dockerpi
ls dockerpi/var/lib/tor
# docker save $IMAGES -o umbrel-docker-images.tar
# du -h umbrel-docker-images.tar
# docker save $IMAGES | gzip > umbrel-docker-images.tar.gz 
# du -h umbrel-docker-images.tar.gz