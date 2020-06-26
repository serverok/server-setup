#!/bin/bash

apt -y install apt-transport-https lsb-release ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

apt update

apt -y install nginx


apt install -y  php7.4-bcmath php7.4-cli php7.4-common php7.4-curl php7.4-gd php7.4-imap php7.4-intl php7.4-json php7.4-mbstring php7.4-mysql php7.4-readline php7.4-soap php7.4-xml php7.4-xmlrpc php7.4-zip

apt -y install php7.4-fpm

phpenmod -v 7.3 simplexml

apt -y install mariadb-client mariadb-server
apt -y install automysqlbackup

echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

apt-get install -y postfix

systemctl enable php7.4-fpm
systemctl enable mariadb
systemctl enable nginx

systemctl restart php7.4-fpm
systemctl restart mariadb
systemctl restart nginx

apt install -y monit
ln -s /etc/monit/conf-available/nginx /etc/monit/conf-enabled/nginx
ln -s /etc/monit/conf-available/mysql /etc/monit/conf-enabled/mysql
systemctl restart monit
