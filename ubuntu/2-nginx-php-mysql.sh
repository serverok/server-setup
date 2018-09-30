#!/bin/bash
# Author: admin@serverOk.in
# Web: https://www.serverok.in

apt-get -y install nginx

apt-get -y install php-cli php-curl php-gd php-mysql php-imagick php-imap php-json
apt-get -y install php-xml php-mbstring php-zip php-xmlrpc php-soap php-intl php-bcmath
apt install -y php-fpm

apt install -y php-mcrypt
phpenmod mcrypt

apt-get -y install mariadb-client mariadb-server
apt install automysqlbackup -y

# echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
# echo "phpmyadmin phpmyadmin/app-password-confirm password " | debconf-set-selections
# echo "phpmyadmin phpmyadmin/mysql/admin-pass password " | debconf-set-selections
# echo "phpmyadmin phpmyadmin/mysql/app-pass password " | debconf-set-selections
# echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections

# apt-get install -y phpmyadmin

echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

apt-get install -y postfix

systemctl enable php7.0-fpm
systemctl enable mysql
systemctl enable nginx

systemctl restart php7.0-fpm
systemctl restart mysql
systemctl restart nginx
