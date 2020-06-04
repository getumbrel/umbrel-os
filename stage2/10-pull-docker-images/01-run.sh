echo "Update docker images, so everything is ready to go"

on_chroot << EOF
docker-compose pull
EOF

