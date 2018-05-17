#!/bin/bash

cd /usr/bin
wget https://dl.eff.org/certbot-auto
chmod a+x /usr/bin/certbot-auto
rm -f /usr/bin/certbot
mv /usr/bin/certbot-auto /usr/bin/certbot

certbot register --update-registration --email admin@serverok.in

crontab -l > /root/crontab-backup
echo "30 2 * * 1 /usr/bin/certbot renew >> /var/log/le-renew.log" >> /root/crontab-backup
crontab /root/crontab-backup
