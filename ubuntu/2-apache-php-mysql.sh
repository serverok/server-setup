#!/bin/bash

apt-get -y install apache2
update-rc.d apache2 enable
a2enmod rewrite
a2enmod ssl

apt-get -y install php php-cli php-curl php-gd \
           php-mysql php-imagick php-imap php-mcrypt \
           php-json php-xml php-mbstring php-zip \
           php-xmlrpc php-soap php-intl php-bcmath

phpenmod mcrypt

# Debian 8
# apt-get -y install php5 php5-cli php5-curl php5-gd php5-mysql php5-imagick php5-imap php5-mcrypt php5-json php5-xmlrpc  php5-intl

#apt -y install php7.0-pgsql

apt-get -y install libapache2-mod-php

apt-get -y install mariadb-client mariadb-server
update-rc.d mysql enable
apt install automysqlbackup -y

echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password " | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password " | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password " | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

apt-get install -y phpmyadmin postfix

cd /etc/php/7.0/apache2
sed -i "s/max_execution_time\s*=.*/max_execution_time = 600/g" php.ini
sed -i "s/max_input_time\s*=.*/max_input_time = 6000/g" php.ini
sed -i "s/memory_limit\s*=.*/memory_limit = 256M/g" php.ini
sed -i "s/display_errors\s*=.*/display_errors = On/g" php.ini
sed -i "s/file_uploads\s*=.*/file_uploads = On/g" php.ini
sed -i "s/post_max_size\s*=.*/post_max_size = 800M/g" php.ini
sed -i "s/upload_max_filesize\s*=.*/upload_max_filesize = 800M/g" php.ini
sed -i "s/session.gc_maxlifetime\s*=.*/session.gc_maxlifetime = 14400/g" php.ini
sed -i "s/error_reporting\s*=.*/error_reporting = E_COMPILE_ERROR|E_ERROR|E_CORE_ERROR/g" php.ini
sed -i "s/max_file_uploads = On/max_file_uploads = 1000/g" php.ini
sed -i 's/; max_input_vars = 1000/max_input_vars = 3000/g' php.ini

service apache2 stop
service apache2 start
