#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

echo "Select PHP version to install:"
echo "1) 7.4"
echo "2) 8.0"
echo "3) 8.1"
echo "4) 8.2"
echo "5) 8.3"
read -p "Enter the number corresponding to the PHP version (1-5): " choice

if ! [[ "$choice" =~ ^[1-5]$ ]]; then
  echo "Invalid input. Please enter a number between 1 and 5."
  exit 1
fi

case $choice in
    1) PHP_VERSION="7.4" ;;
    2) PHP_VERSION="8.0" ;;
    3) PHP_VERSION="8.1" ;;
    4) PHP_VERSION="8.2" ;;
    5) PHP_VERSION="8.3" ;;
    *) PHP_VERSION="8.3" ;;
esac

apt update
apt -y upgrade
apt -y install procps wget curl nmap whois vim git unzip telnet net-tools dnsutils tmux iftop
echo "alias ll='ls -la --color'" >> ~/.bashrc
echo "alias rm='rm -i'" >> ~/.bashrc
echo "alias grep='grep --color=auto'" >> ~/.bashrc
echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> ~/.bashrc

apt-get install -y sysstat
sed -i 's/ENABLED="false"/ENABLED="true"/g' /etc/default/sysstat

systemctl stop apparmor
systemctl disable apparmor

apt-get -y install apache2

a2enmod rewrite
a2enmod ssl
a2enmod headers
a2enmod proxy_fcgi

sed -i 's/#Mutex file:..APACHE_LOCK_DIR. default/Mutex posixsem/g'  /etc/apache2/apache2.conf

systemctl enable apache2
systemctl restart apache2

apt-get install -y software-properties-common

add-apt-repository -y ppa:ondrej/php
apt -y upgrade

apt install -y  php${PHP_VERSION}-bcmath php${PHP_VERSION}-cli php${PHP_VERSION}-common php${PHP_VERSION}-curl php${PHP_VERSION}-gd php${PHP_VERSION}-imap php${PHP_VERSION}-intl php${PHP_VERSION}-mbstring php${PHP_VERSION}-mysql php${PHP_VERSION}-readline php${PHP_VERSION}-soap php${PHP_VERSION}-xml php${PHP_VERSION}-xmlrpc php${PHP_VERSION}-zip php${PHP_VERSION}-gmp

apt -y install php${PHP_VERSION}-fpm

systemctl enable php${PHP_VERSION}-fpm
systemctl restart php${PHP_VERSION}-fpm


curl -sS https://getcomposer.org/installer |  php -- --install-dir=/usr/local/bin --filename=composer

apt -y install mariadb-client mariadb-server
systemctl enable mysql
systemctl restart mysql

echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
apt-get install -y postfix
apt -y install automysqlbackup


apt install -y monit
ln -s /etc/monit/conf-available/mysql /etc/monit/conf-enabled/mysql
ln -s /etc/monit/conf-available/apache2 /etc/monit/conf-enabled/apache2

systemctl enable monit
systemctl restart monit


wget https://raw.githubusercontent.com/serverok/server-setup/master/install/update-php-ini.sh
bash ./update-php-ini.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/install/letsencrypt.sh
bash ./letsencrypt.sh

wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
chmod 755 /usr/local/bin/wp

wget https://raw.githubusercontent.com/serverok/server-setup/master/tools/sok-nginx-add-site.py -O /usr/local/bin/sok-site-add
chmod 755 /usr/local/bin/sok-site-add
