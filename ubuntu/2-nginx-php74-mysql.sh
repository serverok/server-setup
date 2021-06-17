#!/bin/bash
# Author: admin@serverOk.in
# Web: https://serverok.in

apt install -y software-properties-common

add-apt-repository ppa:ondrej/php
apt update
apt -y upgrade

apt update
apt -y install nginx

apt -y install php7.4-cli php7.4-curl php7.4-gd php7.4-mysql php7.4-imagick php7.4-imap php7.4-json \
    php7.4-xml php7.4-mbstring php7.4-zip php7.4-xmlrpc php7.4-soap php7.4-intl php7.4-bcmath \
    php7.4-fpm

apt -y install mariadb-client mariadb-server

echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

apt-get install -y postfix

apt install automysqlbackup -y

systemctl enable mysql
systemctl restart mysql

systemctl enable nginx
systemctl restart nginx

systemctl enable php7.4-fpm
systemctl restart php7.4-fpm

apt install -y monit
ln -s /etc/monit/conf-available/nginx /etc/monit/conf-enabled/
ln -s /etc/monit/conf-available/mysql /etc/monit/conf-enabled/

systemctl enable monit
systemctl start monit

