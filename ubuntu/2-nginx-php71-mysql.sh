#!/bin/bash
# Author: admin@serverOk.in
# Web: https://www.serverok.in

apt install -y software-properties-common

add-apt-repository ppa:ondrej/php
apt -y upgrade

apt update
apt -y install nginx

apt -y install php7.1-cli php7.1-curl php7.1-gd php7.1-mysql php7.1-imagick php7.1-imap php7.1-json
apt -y install php7.1-xml php7.1-mbstring php7.1-zip php7.1-xmlrpc php7.1-soap php7.1-intl php7.1-bcmath php7.1-gmp
apt install -y php7.1-fpm

apt -y install mariadb-client mariadb-server
apt install automysqlbackup -y

echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

apt-get install -y postfix

systemctl enable mysql
systemctl enable nginx

systemctl restart mysql
systemctl restart nginx

systemctl enable php7.1-fpm
systemctl restart php7.1-fpm

apt install -y monit
ln -s /etc/monit/conf-available/nginx /etc/monit/conf-enabled/
ln -s /etc/monit/conf-available/mysql /etc/monit/conf-enabled/

systemctl enable monit
systemctl start monit
