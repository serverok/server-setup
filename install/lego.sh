#!/bin/bash
# Author: ServerOK.in
# Email: admin@serverok.in
# Web; https://serverok.in

cd /tmp
wget https://github.com/go-acme/lego/releases/download/v4.4.0/lego_v4.4.0_linux_amd64.tar.gz
tar xvf lego_v4.4.0_linux_amd64.tar.gz
mv lego /usr/bin
rm -f lego_v4.4.0_linux_amd64.tar.gz CHANGELOG.md LICENSE

crontab -l > /root/crontab-backup
echo "@weekly /usr/serverok/lego-renew >> /var/log/lego-renew.log" >> /root/crontab-backup
crontab /root/crontab-backup
mv /root/crontab-backup /tmp/crontab-backup-$(date "+%Y-%m-%d-%H-%M-%S")

mkdir /usr/serverok/
wget https://raw.githubusercontent.com/serverok/server-setup/master/data/letsencrypt-renew.sh -O /usr/serverok/lego-renew
chmod 755 /usr/serverok/lego-renew

if [ -f /usr/sbin/apache2 ]; then
    sed -i 's/#systemctl restart apache2/systemctl restart apache2/g' /usr/serverok/lego-renew
fi

if [ -f /usr/sbin/nginx ]; then
    sed -i 's/#systemctl restart nginx/systemctl restart nginx/g' /usr/serverok/lego-renew
fi
