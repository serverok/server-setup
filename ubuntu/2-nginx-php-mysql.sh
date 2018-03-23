#!/bin/bash

apt-get -y install nginx

apt-get -y install php php-cli php-curl php-gd \
           php-mysql php-imagick php-imap php-mcrypt \
           php-json php-xml php-mbstring php-zip \
           php-xmlrpc php-soap php-intl php-bcmath \
           php-fpm

phpenmod mcrypt

cd /etc/php/7.0/fpm/
/bin/sed -i "s/max_execution_time\s*=.*/max_execution_time = 600/g" php.ini
/bin/sed -i "s/max_input_time\s*=.*/max_input_time = 6000/g" php.ini
/bin/sed -i "s/memory_limit\s*=.*/memory_limit = 128M/g" php.ini
/bin/sed -i "s/display_errors\s*=.*/display_errors = On/g" php.ini
/bin/sed -i "s/file_uploads\s*=.*/file_uploads = On/g" php.ini
/bin/sed -i "s/post_max_size\s*=.*/post_max_size = 800M/g" php.ini
/bin/sed -i "s/upload_max_filesize\s*=.*/upload_max_filesize = 800M/g" php.ini
/bin/sed -i "s/session.gc_maxlifetime\s*=.*/session.gc_maxlifetime = 14400/g" php.ini
/bin/sed -i "s/error_reporting\s*=.*/error_reporting = E_COMPILE_ERROR|E_ERROR|E_CORE_ERROR/g" php.ini
/bin/sed -i "s/max_file_uploads = On/max_file_uploads = 1000/g" php.ini

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

systemctl enable php7.0-fpm
systemctl enable mysql
systemctl enable nginx

systemctl restart php7.0-fpm
systemctl restart mysql
systemctl restart nginx
