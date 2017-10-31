#!/bin/bash

apt-get -y install nginx

apt-get -y install php php-cli php-curl php-gd \
           php-mysql php-imagick php-imap php-mcrypt \
           php-json php-xml php-mbstring php-zip \
           php-xmlrpc php-soap php-intl php-bcmath \
           php-fpm

phpenmod mcrypt

apt-get -y install mariadb-client mariadb-server


echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password " | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password " | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password " | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections

apt-get install -y phpmyadmin

echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

apt-get install -y postfix


systemctl enable mysql
systemctl enable nginx
