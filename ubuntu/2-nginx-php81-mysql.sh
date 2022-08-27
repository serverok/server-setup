#!/bin/bash
# Author: admin@serverOk.in
# Web: https://serverok.in

apt install -y software-properties-common

add-apt-repository ppa:ondrej/php
apt update
apt -y upgrade

apt update
apt -y install nginx

apt -y install php8.1-cli php8.1-curl php8.1-gd php8.1-mysql php8.1-imagick php8.1-imap  \
    php8.1-xml php8.1-mbstring php8.1-zip php8.1-xmlrpc php8.1-soap php8.1-intl php8.1-bcmath \
    php8.1-fpm

apt -y install mariadb-client mariadb-server

echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

apt-get install -y postfix

apt install automysqlbackup -y

systemctl enable mysql
systemctl restart mysql

systemctl enable nginx
systemctl restart nginx

systemctl enable php8.1-fpm
systemctl restart php8.1-fpm

apt install -y monit
ln -s /etc/monit/conf-available/nginx /etc/monit/conf-enabled/
ln -s /etc/monit/conf-available/mysql /etc/monit/conf-enabled/

systemctl enable monit
systemctl start monit

