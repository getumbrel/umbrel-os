echo "Adding lncm to DOCKER group"
on_chroot << EOF
usermod -a -G docker $FIRST_USER_NAME
EOF

