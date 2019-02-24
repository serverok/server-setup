#!/bin/bash
# Author: ServerOK.in
# Email: admin@serverok.in
# Web; https://www.serverok.in

cd /usr/bin
wget https://dl.eff.org/certbot-auto
chmod a+x /usr/bin/certbot-auto
rm -f /usr/bin/certbot
mv /usr/bin/certbot-auto /usr/bin/certbot
/usr/bin/certbot --install-only

crontab -l > /root/crontab-backup
echo "30 2 * * 1 /usr/serverok/ssl-renew >> /var/log/le-renew.log" >> /root/crontab-backup
crontab /root/crontab-backup

mkdir /usr/serverok/
wget https://raw.githubusercontent.com/serverok/server-setup/master/data/letsencrypt-renew.sh -O /usr/serverok/ssl-renew
chmod 755 /usr/serverok/ssl-renew
