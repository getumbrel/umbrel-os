#!/bin/bash -e
echo "Installing Docker"
on_chroot << EOF
export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
curl -fsSL https://get.docker.com | sh
EOF

echo "Adding user to the 'docker' group"
echo "Also fixing permissions on folders"
on_chroot << EOF
usermod -a -G docker $FIRST_USER_NAME
chown -R $FIRST_USER_NAME:$FIRST_USER_NAME /home/$FIRST_USER_NAME
EOF