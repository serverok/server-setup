#!/bin/bash
# Author: admin@serverOk.in
# Web: https://serverok.in

apt install -y software-properties-common

add-apt-repository ppa:ondrej/php
apt update
apt -y upgrade

apt update
apt -y install nginx

apt -y install php8.2-cli php8.2-curl php8.2-gd php8.2-mysql php8.2-imagick php8.2-imap  \
    php8.2-xml php8.2-mbstring php8.2-zip php8.2-xmlrpc php8.2-soap php8.2-intl php8.2-bcmath \
    php8.2-fpm

apt -y install mariadb-client mariadb-server

echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

apt-get install -y postfix

apt install automysqlbackup -y

systemctl enable mysql
systemctl restart mysql

systemctl enable nginx
systemctl restart nginx

systemctl enable php8.2-fpm
systemctl restart php8.2-fpm

apt install -y monit
ln -s /etc/monit/conf-available/nginx /etc/monit/conf-enabled/
ln -s /etc/monit/conf-available/mysql /etc/monit/conf-enabled/

systemctl enable monit
systemctl start monit

