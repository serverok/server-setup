#!/bin/bash
# Author: admin@serverOk.in
# Web: https://www.serverok.in

apt install -y software-properties-common

add-apt-repository ppa:ondrej/php
apt -y upgrade

apt update
apt -y install nginx

apt -y install php7.2-cli php7.2-curl php7.2-gd php7.2-mysql php7.2-imagick php7.2-imap php7.2-json
apt -y install php7.2-xml php7.2-mbstring php7.2-zip php7.2-xmlrpc php7.2-soap php7.2-intl php7.2-bcmath php7.2-gmp
apt install -y php7.2-fpm

apt -y install mariadb-client mariadb-server
apt install automysqlbackup -y

echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

apt-get install -y postfix

systemctl enable mysql
systemctl enable nginx

systemctl restart mysql
systemctl restart nginx

systemctl enable php7.2-fpm
systemctl restart php7.2-fpm

apt install -y monit
ln -s /etc/monit/conf-available/nginx /etc/monit/conf-enabled/
ln -s /etc/monit/conf-available/mysql /etc/monit/conf-enabled/

systemctl enable monit
systemctl start monit
