#!/bin/bash
# Author: admin@serverOk.in
# Web: https://www.serverok.in

add-apt-repository ppa:ondrej/php
apt update
apt -y upgrade

# remove other version of php 7 if installed.
# dpkg -l | grep php | cut -d" " -f3 | xargs apt purge -y
# apt purge -y php php-bcmath php-cli php-common php-curl php-fpm php-gd

apt install -y php5.6 php5.6-mysql php5.6-gd php5.6-mbstring php5.6-mcrypt php5.6-zip php5.6-curl php5.6-xml

apt install libapache2-mod-php5.6
a2enmod rewrite


phpenmod -v 5.6 simplexml


#apt install -y php5.6-fpm


cd /etc/php/5.6/fpm/
cd /etc/php/5.6/apache2/

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

service apache2 restart
service php5.6-fpm restart
