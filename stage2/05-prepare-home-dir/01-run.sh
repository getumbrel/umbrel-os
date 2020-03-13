# Save password (for createwallet script).
# We will remove this later when a more suitable secure system is finalized.
touch $ROOTFS_DIR/home/$FIRST_USER_NAME/.save_password

echo "Executables directory"
mkdir -p $ROOTFS_DIR/home/$FIRST_USER_NAME/bin

