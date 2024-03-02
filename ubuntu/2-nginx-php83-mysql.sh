#!/bin/bash
# Author: admin@serverOk.in
# Web: https://serverok.in

apt install -y software-properties-common

add-apt-repository ppa:ondrej/php
apt update
apt -y upgrade

apt update
apt -y install nginx

apt -y install php8.3-cli php8.3-curl php8.3-gd php8.3-mysql php8.3-imagick php8.3-imap  \
    php8.3-xml php8.3-mbstring php8.3-zip php8.3-xmlrpc php8.3-soap php8.3-intl php8.3-bcmath \
    php8.3-fpm

apt -y install mariadb-client mariadb-server

echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

apt-get install -y postfix

apt install automysqlbackup -y

systemctl enable mysql
systemctl restart mysql

systemctl enable nginx
systemctl restart nginx

systemctl enable php8.3-fpm
systemctl restart php8.3-fpm

apt install -y monit
ln -s /etc/monit/conf-available/nginx /etc/monit/conf-enabled/
ln -s /etc/monit/conf-available/mysql /etc/monit/conf-enabled/

systemctl enable monit
systemctl start monit

