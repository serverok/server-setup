#!/bin/bash

apt -y install apt-transport-https lsb-release ca-certificates

wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg

echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

apt-get update

apt -y install nginx


apt install -y  php7.2-bcmath php7.2-cli php7.2-common php7.2-curl php7.2-gd php7.2-imap php7.2-intl php7.2-json php7.2-mbstring php7.2-mysql php7.2-readline php7.2-soap php7.2-xml php7.2-xmlrpc php7.2-zip

apt -y install php7.2-fpm

phpenmod -v 7.2 simplexml

apt-get -y install mariadb-client mariadb-server

echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

apt-get install -y postfix

systemctl enable php7.2-fpm
systemctl enable mariadb
systemctl enable nginx

systemctl restart php7.2-fpm
systemctl restart mariadb
systemctl restart nginx

apt install -y monit
ln -s /etc/monit/conf-available/nginx /etc/monit/conf-enabled/nginx
ln -s /etc/monit/conf-available/mysql /etc/monit/conf-enabled/mysql
systemctl restart monit
