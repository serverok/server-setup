#!/bin/bash
# Author: admin@serverOk.in
# Web: https://www.serverok.in

apt-get -y install apache2
update-rc.d apache2 enable
a2enmod rewrite
a2enmod ssl

sed -i 's/#Mutex file:..APACHE_LOCK_DIR. default/Mutex posixsem/g'  /etc/apache2/apache2.conf

add-apt-repository ppa:ondrej/php
apt -y upgrade

apt -y install php5.6-bcmath php5.6-bz2 php5.6-cgi php5.6-cli php5.6-common php5.6-curl php5.6-dba php5.6-dev php5.6-enchant php5.6-gd php5.6-gmp php5.6-imap php5.6-intl php5.6-json php5.6-mbstring php5.6-mysql php5.6-opcache php5.6-pgsql php5.6-pspell php5.6-readline php5.6-soap php5.6-sqlite3 php5.6-sybase php5.6-tidy php5.6-xml php5.6-xmlrpc php5.6-zip php5.6-xsl php5.6-mcrypt
apt -y install libapache2-mod-php5.6

apt-get -y install mariadb-client mariadb-server
update-rc.d mysql enable

echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

apt-get install -y postfix

service apache2 stop
service apache2 start

apt install -y monit
ln -s /etc/monit/conf-available/apache2 /etc/monit/conf-enabled/
ln -s /etc/monit/conf-available/mysql /etc/monit/conf-enabled/

apt install automysqlbackup -y

systemctl enable monit
systemctl start monit
