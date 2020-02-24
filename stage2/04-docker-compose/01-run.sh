# Install docker via pip3 (within chroot)

on_chroot << EOF
pip3 install docker-compose
EOF

# Maybe generate a compose file to use
echo "Docker stuff installed" >> $ROOTFS_DIR/home/$FIRST_USER_NAME/docker-compose.txt


