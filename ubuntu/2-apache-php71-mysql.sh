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

apt install php7.1

apt install php7.1-bcmath php7.1-bz2 php7.1-cgi php7.1-cli php7.1-common php7.1-curl php7.1-dba php7.1-dev php7.1-enchant php7.1-gd php7.1-gmp php7.1-imap php7.1-intl php7.1-json php7.1-mbstring php7.1-mysql php7.1-opcache php7.1-pgsql php7.1-pspell php7.1-readline php7.1-soap php7.1-sqlite3 php7.1-sybase php7.1-tidy php7.1-xml php7.1-xmlrpc php7.1-zip php7.1-xsl php7.1-gmp

apt install libapache2-mod-php7.1

a2enmod php7.1

systemctl enable apache2
systemctl start apache2

apt-get -y install mysql-server-5.7

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
