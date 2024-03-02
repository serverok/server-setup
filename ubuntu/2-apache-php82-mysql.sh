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

apt install php8.2

apt install -y php8.2-bcmath php8.2-bz2 php8.2-cgi php8.2-cli php8.2-common php8.2-curl php8.2-dba php8.2-dev php8.2-enchant php8.2-gd php8.2-gmp php8.2-imap php8.2-intl php8.2-mbstring php8.2-mysql php8.2-opcache php8.2-pgsql php8.2-pspell php8.2-readline php8.2-soap php8.2-sqlite3 php8.2-sybase php8.2-tidy php8.2-xml php8.2-zip php8.2-xsl php8.2-gmp

apt install -y libapache2-mod-php8.2

a2dismod php7.4
a2enmod php8.2

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
