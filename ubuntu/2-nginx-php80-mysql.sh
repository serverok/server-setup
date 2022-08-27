#!/bin/bash
# Author: admin@serverOk.in
# Web: https://serverok.in

apt install -y software-properties-common

add-apt-repository ppa:ondrej/php
apt update
apt -y upgrade

apt update
apt -y install nginx

apt -y install php8.0-cli php8.0-curl php8.0-gd php8.0-mysql php8.0-imagick php8.0-imap  \
    php8.0-xml php8.0-mbstring php8.0-zip php8.0-xmlrpc php8.0-soap php8.0-intl php8.0-bcmath \
    php8.0-fpm

apt -y install mariadb-client mariadb-server

echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

apt-get install -y postfix

apt install automysqlbackup -y

systemctl enable mysql
systemctl restart mysql

systemctl enable nginx
systemctl restart nginx

systemctl enable php8.0-fpm
systemctl restart php8.0-fpm

apt install -y monit
ln -s /etc/monit/conf-available/nginx /etc/monit/conf-enabled/
ln -s /etc/monit/conf-available/mysql /etc/monit/conf-enabled/

systemctl enable monit
systemctl start monit

