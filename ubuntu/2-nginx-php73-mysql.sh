#!/bin/bash
# Author: admin@serverOk.in
# Web: https://www.serverok.in

apt install -y software-properties-common

add-apt-repository ppa:ondrej/php
apt update
apt -y upgrade

apt update
apt -y install nginx

apt -y install php-cli php-curl php-gd php-mysql php-imagick php-imap php-json
apt -y install php-xml php-mbstring php-zip php-xmlrpc php-soap php-intl php-bcmath
apt install -y php-fpm

apt install -y php-mcrypt
phpenmod mcrypt

apt -y install mariadb-client mariadb-server
apt install automysqlbackup -y

echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

apt-get install -y postfix

systemctl enable mysql
systemctl enable nginx

systemctl restart mysql
systemctl restart nginx

systemctl enable php7.3-fpm
systemctl restart php7.3-fpm
