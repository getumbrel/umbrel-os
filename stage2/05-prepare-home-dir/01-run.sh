# Test out image
echo "Hello World" >> $ROOTFS_DIR/home/$FIRST_USER_NAME/hello.txt

# Save password (for createwallet script).
# We will remove this later when a more suitable secure system is finalized.

touch $ROOTFS_DIR/home/$FIRST_USER_NAME/.save_password


