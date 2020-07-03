#!/bin/bash -e

docker --version
echo '{"experimental": true}' | sudo tee -a /etc/docker/daemon.json
wget -q "https://raw.githubusercontent.com/getumbrel/umbrel-compose/master/docker-compose.yml"
IMAGES=$(grep '^\s*image' docker-compose.yml | sed 's/image://' | sed 's/\"//g' | sed '/^$/d;s/[[:blank:]]//g' | sort | uniq)
echo "List of images to download: $IMAGES"
while IFS= read -r image; do
    docker pull --platform=linux/arm/v7 $image
done <<< "$IMAGES"
docker images 
docker save $IMAGES -o umbrel-docker-images.tar
ls -al