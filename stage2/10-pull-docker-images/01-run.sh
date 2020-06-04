echo "Update docker images, so everything is ready to go"

on_chroot << EOF
cd /home/umbrel
docker-compose pull
EOF

