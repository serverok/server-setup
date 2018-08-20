#!/bin/bash

apt -y install nginx

apt -y install php-cli php-curl php-gd php-mysql php-imagick php-imap php-mcrypt \
       php-json php-xml php-mbstring php-zip php-xmlrpc php-soap php-intl php-bcmath

apt -y install php-fpm

phpenmod mcrypt

apt-get -y install mariadb-client mariadb-server

echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

apt-get install -y postfix

systemctl enable php7.0-fpm
systemctl enable mariadb
systemctl enable nginx

systemctl restart php7.0-fpm
systemctl restart mariadb
systemctl restart nginx
