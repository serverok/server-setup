#!/bin/bash

apt-get -y install apache2
systemctl enable apache2
a2enmod rewrite
a2enmod ssl

sed -i 's/#Mutex file:..APACHE_LOCK_DIR. default/Mutex posixsem/g'  /etc/apache2/apache2.conf

apt-get -y install php php-cli php-curl php-gd \
           php-mysql php-imagick php-imap  \
           php-json php-xml php-mbstring php-zip \
           php-xmlrpc php-soap php-intl php-bcmath

# not in Debian 10
apt-get install -y php-mcrypt
phpenmod mcrypt

# Debian 8
# apt-get -y install php5 php5-cli php5-curl php5-gd php5-mysql php5-imagick php5-imap php5-mcrypt php5-json php5-xmlrpc  php5-intl

#apt -y install php7.0-pgsql

apt-get -y install libapache2-mod-php
#apt install -y libapache2-mod-php7.3

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
