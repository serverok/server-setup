#!/bin/bash
# Author: admin@serverOk.in
# Web: https://serverok.in

apt-get -y install apache2
apt -y install libapache2-mod-ruid2
update-rc.d apache2 enable
a2enmod rewrite
a2enmod ssl
a2enmod headers

sed -i 's/#Mutex file:..APACHE_LOCK_DIR. default/Mutex posixsem/g'  /etc/apache2/apache2.conf

apt-get install software-properties-common

add-apt-repository ppa:ondrej/php
apt update
apt -y upgrade

apt install php8.1

apt install -y php8.1-bcmath php8.1-bz2 php8.1-cgi php8.1-cli php8.1-common php8.1-curl php8.1-dba php8.1-dev php8.1-enchant php8.1-gd php8.1-gmp php8.1-imap php8.1-intl php8.1-mbstring php8.1-mysql php8.1-opcache php8.1-pgsql php8.1-pspell php8.1-readline php8.1-soap php8.1-sqlite3 php8.1-sybase php8.1-tidy php8.1-xml php8.1-xmlrpc php8.1-zip php8.1-xsl php8.1-gmp

apt install -y libapache2-mod-php8.1

a2dismod php7.4
a2enmod php8.1

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
