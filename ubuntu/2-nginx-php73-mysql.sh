#!/bin/bash
# Author: admin@serverOk.in
# Web: https://www.serverok.in

apt install -y software-properties-common

add-apt-repository ppa:ondrej/php
apt -y upgrade

apt update
apt -y install nginx

apt -y install php7.3-cli php7.3-curl php7.3-gd php7.3-mysql php7.3-imagick php7.3-imap php7.3-json
apt -y install php7.3-xml php7.3-mbstring php7.3-zip php7.3-xmlrpc php7.3-soap php7.3-intl php7.3-bcmath php7.3-gmp
apt install -y php7.3-fpm

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

apt install -y monit
ln -s /etc/monit/conf-available/nginx /etc/monit/conf-enabled/
ln -s /etc/monit/conf-available/mysql /etc/monit/conf-enabled/

systemctl enable monit
systemctl start monit
