#!/bin/bash
# Author: admin@serverOk.in
# Web: https://www.serverok.in

apt-get -y install apache2
apt -y install libapache2-mod-ruid2
update-rc.d apache2 enable
a2enmod rewrite
a2enmod ssl

sed -i 's/#Mutex file:..APACHE_LOCK_DIR. default/Mutex posixsem/g'  /etc/apache2/apache2.conf

apt-get -y install php php-cli php-curl php-gd \
           php-mysql php-imagick php-imap  \
           php-json php-xml php-mbstring php-zip \
           php-xmlrpc php-soap php-intl php-bcmath


# Debian 8
# apt-get -y install php5 php5-cli php5-curl php5-gd php5-mysql php5-imagick php5-imap php5-mcrypt php5-json php5-xmlrpc  php5-intl

#apt -y install php7.0-pgsql

apt-get -y install libapache2-mod-php

apt-get -y install mariadb-client mariadb-server
update-rc.d mysql enable
apt install automysqlbackup -y

echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

apt install -y postfix

echo '$cfg["blowfish_secret"] = "ohhae8Fa6oJohrohng0ieV0to3aiThae";' >> /etc/phpmyadmin/config.inc.php

service apache2 stop
service apache2 start

apt install -y monit
ln -s /etc/monit/conf-available/apache2 /etc/monit/conf-enabled/
ln -s /etc/monit/conf-available/mysql /etc/monit/conf-enabled/

systemctl enable monit
systemctl start monit
