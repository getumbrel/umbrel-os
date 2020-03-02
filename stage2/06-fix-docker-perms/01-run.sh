echo "Adding lncm to DOCKER group"
echo "Also fixing permissions on folders"
on_chroot << EOF
usermod -a -G docker $FIRST_USER_NAME
chown -R $FIRST_USER_NAME:$FIRST_USER_NAME /home/$FIRST_USER_NAME
EOF

