#!/bin/bash

apt-get -y install apache2
update-rc.d apache2 enable
a2enmod rewrite

apt-get -y install php php-cli php-curl php-gd php-mysql php-imagick php-imap php-mcrypt php-json php-xml php-mbstring php-zip php-xmlrpc php-soap php-intl
phpenmod mcrypt

# Debian 8
# apt-get -y install php5 php5-cli php5-curl php5-gd php5-mysql php5-imagick php5-imap php5-mcrypt php5-json php5-xmlrpc  php5-intl

#apt -y install php7.0-pgsql

apt-get -y install libapache2-mod-php

apt-get -y install mariadb-client mariadb-server
update-rc.d mysql enable


apt -y install phpmyadmin
apt -y install postfix

service apache2 stop
service apache2 start

