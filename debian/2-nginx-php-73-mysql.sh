#!/bin/bash

apt -y install apt-transport-https lsb-release ca-certificates
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

apt update

apt -y install nginx


apt install -y  php7.3-bcmath php7.3-cli php7.3-common php7.3-curl php7.3-gd php7.3-imap php7.3-intl php7.3-json php7.3-mbstring php7.3-mysql php7.3-readline php7.3-soap php7.3-xml php7.3-xmlrpc php7.3-zip

apt -y install php7.3-fpm

phpenmod -v 7.3 simplexml

apt -y install mariadb-client mariadb-server
apt -y install automysqlbackup

echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

apt-get install -y postfix

systemctl enable php7.3-fpm
systemctl enable mariadb
systemctl enable nginx

systemctl restart php7.3-fpm
systemctl restart mariadb
systemctl restart nginx

apt install -y monit
ln -s /etc/monit/conf-available/nginx /etc/monit/conf-enabled/nginx
ln -s /etc/monit/conf-available/mysql /etc/monit/conf-enabled/mysql
systemctl restart monit
