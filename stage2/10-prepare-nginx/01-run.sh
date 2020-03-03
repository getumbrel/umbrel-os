chmod 644 files/nginx.conf
chmod 644 files/mime.types

mkdir -p ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/nginx
cp files/nginx.conf   ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/nginx/nginx.conf
cp files/mime.types   ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/nginx/mime.types

echo "Create same folder structure"
cp -fr files/www   ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/nginx
cp -fr files/log   ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/nginx
cp -fr files/conf.d   ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/nginx

echo "Fix up permissions of all config files"
on_chroot << EOF
chown -r ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}
EOF

