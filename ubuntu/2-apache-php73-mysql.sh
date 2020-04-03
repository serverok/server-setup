#!/bin/bash
# Author: admin@serverOk.in
# Web: https://www.serverok.in

apt-get -y install apache2
apt -y install libapache2-mod-ruid2
systemctl enable apache2
a2enmod rewrite
a2enmod ssl
systemctl restart apache2

sed -i 's/#Mutex file:..APACHE_LOCK_DIR. default/Mutex posixsem/g'  /etc/apache2/apache2.conf

apt-get install software-properties-common

add-apt-repository ppa:ondrej/php
apt update
apt -y upgrade

apt install php7.3

apt install php7.3-bcmath php7.3-bz2 php7.3-cgi php7.3-cli php7.3-common php7.3-curl php7.3-dba php7.3-dev php7.3-enchant php7.3-gd php7.3-gmp php7.3-imap php7.3-intl php7.3-json php7.3-mbstring php7.3-mysql php7.3-opcache php7.3-pgsql php7.3-pspell php7.3-readline php7.3-soap php7.3-sqlite3 php7.3-sybase php7.3-tidy php7.3-xml php7.3-xmlrpc php7.3-zip php7.3-xsl php7.3-gmp

apt install libapache2-mod-php7.3

a2enmod php7.3

systemctl enable apache2
systemctl start apache2

apt-get -y install mariadb-client mariadb-server

systemctl enable mysql

echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
apt-get install -y postfix

apt install -y monit
ln -s /etc/monit/conf-available/apache2 /etc/monit/conf-enabled/
ln -s /etc/monit/conf-available/mysql /etc/monit/conf-enabled/

systemctl enable monit
systemctl start monit

apt install automysqlbackup -y
