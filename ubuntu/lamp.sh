#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

PHP_VERSIONS=("7.2" "7.4" "8.0" "8.1" "8.2" "8.3" "8.4")

echo "Select PHP version to install:"
for i in "${!PHP_VERSIONS[@]}"; do
    echo "$((i+1))) ${PHP_VERSIONS[$i]}"
done

read -p "Enter the number corresponding to the PHP version (1-${#PHP_VERSIONS[@]}): " choice

if ! [[ "$choice" =~ ^[1-9][0-9]*$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#PHP_VERSIONS[@]}" ]; then
  echo "Invalid input. Please enter a number between 1 and ${#PHP_VERSIONS[@]}."
  exit 1
fi

PHP_VERSION="${PHP_VERSIONS[$((choice-1))]}"

echo "You selected PHP $PHP_VERSION"

apt update
apt -y upgrade
apt -y install procps wget curl nmap whois vim git unzip telnet net-tools dnsutils tmux iftop
echo "alias ll='ls -la --color'" >> ~/.bashrc
echo "alias rm='rm -i'" >> ~/.bashrc
echo "alias grep='grep --color=auto'" >> ~/.bashrc
echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> ~/.bashrc

apt-get install -y sysstat
sed -i 's/ENABLED="false"/ENABLED="true"/g' /etc/default/sysstat

echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config.d/00-serverok.conf
systemctl restart ssh

systemctl stop apparmor
systemctl disable apparmor

apt-get -y install apache2

a2enmod rewrite
a2enmod ssl
a2enmod headers
a2enmod proxy_fcgi

sed -i 's/#Mutex file:..APACHE_LOCK_DIR. default/Mutex posixsem/g'  /etc/apache2/apache2.conf
sed -i "s/ServerSignature On/ServerSignature Off/g" /etc/apache2/conf-available/security.conf
sed -i "s/^ServerTokens .*/ServerTokens Prod/g" /etc/apache2/conf-available/security.conf
sed -i "s/TraceEnable On/TraceEnable Off/g" /etc/apache2/conf-available/security.conf

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

mkdir /usr/serverok/
rm -rf /usr/serverok/phpmyadmin

cd /usr/local/src
rm -f phpMyAdmin-5.2.3-all-languages.tar.xz
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.3/phpMyAdmin-5.2.3-all-languages.tar.xz
tar xvf phpMyAdmin-5.2.3-all-languages.tar.xz
mv phpMyAdmin-5.2.3-all-languages /usr/serverok/phpmyadmin

cd /usr/serverok/phpmyadmin/
mkdir tmp
chmod 777 tmp
cp config.sample.inc.php config.inc.php
sed -i  's/$cfg\[.blowfish_secret.\] = .*$/$cfg\["blowfish_secret"\] = "ohhae8Fa6oJohrohng0ieV0to3aiThae";/g' config.inc.php

cat <<EOF > /etc/apache2/sites-available/phpmyadmin.conf
Listen 7777

<VirtualHost *:7777>
  DocumentRoot /usr/serverok/phpmyadmin/
  CustomLog \${APACHE_LOG_DIR}/pma.log combined
  <FilesMatch \.php\$>
    SetHandler "proxy:unix:/run/php/php${PHP_VERSION}-fpm.sock|fcgi://localhost/"
  </FilesMatch>
  <Directory "/usr/serverok/phpmyadmin">
    Options All
    AllowOverride All
    Require all granted
    Order allow,deny
    allow from all
  </Directory>
</VirtualHost>
EOF

a2ensite phpmyadmin.conf

systemctl restart apache2

wget https://raw.githubusercontent.com/serverok/server-setup/master/install/update-php-ini.sh
bash ./update-php-ini.sh

wget https://raw.githubusercontent.com/serverok/server-setup/master/install/letsencrypt.sh
bash ./letsencrypt.sh

wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
chmod 755 /usr/local/bin/wp

curl -s https://raw.githubusercontent.com/serverok/server-manager/master/install.sh | bash


mkdir -p /usr/serverok/okpanel/config/
echo "apache" > /usr/serverok/okpanel/config/webserver

