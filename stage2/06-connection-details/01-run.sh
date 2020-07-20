#!/bin/bash -e

echo "Installing connection-details and dependencies"

cp files/Pipfile* ${ROOTFS_DIR}/

on_chroot << EOF
PIPENV_PIPFILE="/Pipfile" pipenv --python "$(which python3)" install --system
EOF

rm ${ROOTFS_DIR}/Pipfile*

chmod +x files/connection-details
cp files/connection-details ${ROOTFS_DIR}/usr/local/bin/connection-details
