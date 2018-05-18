dd if=/dev/zero of=/swapfile bs=1M count=2048
mkswap /swapfile
chmod 0600 /swapfile
swapon  /swapfile
echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
