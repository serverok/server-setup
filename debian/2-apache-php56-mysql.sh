#!/bin/bash

apt-get -y install apache2
systemctl enable apache2
a2enmod rewrite
a2enmod ssl

sed -i 's/#Mutex file:..APACHE_LOCK_DIR. default/Mutex posixsem/g'  /etc/apache2/apache2.conf

apt install apt-transport-https lsb-release ca-certificates -y
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list


apt-get update

apt install -y  php5.6-bcmath php5.6-cli php5.6-common php5.6-curl php5.6-gd php5.6-imap php5.6-intl php5.6-json php5.6-mbstring php5.6-mcrypt php5.6-mysql php5.6-readline php5.6-soap php5.6-xml php5.6-xmlrpc php5.6-zip

phpenmod -v 5.6 simplexml

apt install libapache2-mod-php5.6

apt-get -y install mariadb-client mariadb-server
systemctl enable mariadb

echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

apt install -y postfix

systemctl stop apache2
systemctl start apache2
systemctl status apache2

apt install -y monit
ln -s /etc/monit/conf-available/apache2 /etc/monit/conf-enabled/
ln -s /etc/monit/conf-available/mysql /etc/monit/conf-enabled/
