echo "Update docker images, so everything is ready to go"

on_chroot << EOF
cd /hpme/umbrel
docker-compose pull
EOF

