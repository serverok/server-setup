#!/bin/bash
# Author: admin@serverOk.in
# Web: https://www.serverok.in

apt-get -y install apache2
apt -y install libapache2-mod-ruid2
systemctl enable apache2
a2enmod rewrite
a2enmod ssl
a2enmod headers

sed -i 's/#Mutex file:..APACHE_LOCK_DIR. default/Mutex posixsem/g'  /etc/apache2/apache2.conf

apt-get install software-properties-common

add-apt-repository ppa:ondrej/php
apt update
apt -y upgrade

apt install php8.0

apt install -y php8.0-bcmath php8.0-bz2 php8.0-cgi php8.0-cli php8.0-common php8.0-curl php8.0-dba php8.0-dev php8.0-enchant php8.0-gd php8.0-gmp php8.0-imap php8.0-intl php8.0-mbstring php8.0-mysql php8.0-opcache php8.0-pgsql php8.0-pspell php8.0-readline php8.0-soap php8.0-sqlite3 php8.0-sybase php8.0-tidy php8.0-xml php8.0-xmlrpc php8.0-zip php8.0-xsl php8.0-gmp

apt install -y libapache2-mod-php8.0

a2dismod php7.4
a2enmod php8.0

systemctl restart apache2

apt-get -y install mariadb-client mariadb-server
systemctl enable mysql
apt install automysqlbackup -y

echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

apt-get install -y postfix

service apache2 stop
service apache2 start

apt install -y monit
ln -s /etc/monit/conf-available/apache2 /etc/monit/conf-enabled/
ln -s /etc/monit/conf-available/mysql /etc/monit/conf-enabled/

systemctl enable monit
systemctl start monit
