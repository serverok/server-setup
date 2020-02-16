#!/bin/bash
# Author: admin@serverOk.in
# Web: https://www.serverok.in

apt-get -y install apache2
apt -y install libapache2-mod-ruid2
update-rc.d apache2 enable
a2enmod rewrite
a2enmod ssl

sed -i 's/#Mutex file:..APACHE_LOCK_DIR. default/Mutex posixsem/g'  /etc/apache2/apache2.conf

apt-get install software-properties-common

add-apt-repository ppa:ondrej/php
apt update
apt -y upgrade

apt install php7.4

apt install php7.4-bcmath php7.4-bz2 php7.4-cgi php7.4-cli php7.4-common php7.4-curl php7.4-dba php7.4-dev php7.4-enchant php7.4-gd php7.4-gmp php7.4-imap php7.4-intl php7.4-json php7.4-mbstring php7.4-mysql php7.4-opcache php7.4-pgsql php7.4-pspell php7.4-readline php7.4-soap php7.4-sqlite3 php7.4-sybase php7.4-tidy php7.4-xml php7.4-xmlrpc php7.4-zip php7.4-xsl php7.4-gmp

apt install libapache2-mod-php7.4


a2enmod php7.4

service apache2 restart

apt-get -y install mariadb-client mariadb-server
update-rc.d mysql enable
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
