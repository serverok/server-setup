#!/bin/bash

apt -y install apt-transport-https lsb-release ca-certificates

wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg

echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

apt-get update

apt -y install nginx


apt install -y  php5.6-bcmath php5.6-cli php5.6-common php5.6-curl php5.6-gd php5.6-imap php5.6-intl php5.6-json php5.6-mbstring php5.6-mysql php5.6-readline php5.6-soap php5.6-xml php5.6-xmlrpc php5.6-zip

apt -y install php5.6-fpm



apt -y install mariadb-client mariadb-server
apt -y install automysqlbackup


echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

apt-get install -y postfix

systemctl enable php5.6-fpm
systemctl enable mariadb
systemctl enable nginx

systemctl restart php5.6-fpm
systemctl restart mariadb
systemctl restart nginx

apt install -y monit
ln -s /etc/monit/conf-available/nginx /etc/monit/conf-enabled/nginx
ln -s /etc/monit/conf-available/mysql /etc/monit/conf-enabled/mysql
systemctl restart monit
