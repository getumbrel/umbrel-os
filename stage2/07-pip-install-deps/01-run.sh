echo "Install Python dependencies"

## Add in any python dependencies within the chroot
on_chroot << EOF
pip3 install noma
EOF


