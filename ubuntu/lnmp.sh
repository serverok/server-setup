#!/bin/bash
# Author: Yujin Boby <admin@serverok.in>
# Website: https://serverok.in
# Description: Install Nginx, PHP and MariaDB.

export DEBIAN_FRONTEND=noninteractive

# Prompt the user for PHP version if no command-line argument is provided
echo "Select PHP version to install:"
echo "1) 7.4"
echo "2) 8.0"
echo "3) 8.1"
echo "4) 8.2"
echo "5) 8.3"
read -p "Enter the number corresponding to the PHP version (1-5): " choice

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

rm -f /etc/update-motd.d/*

apt -y install nginx
systemctl enable nginx
systemctl restart nginx

apt install -y software-properties-common
add-apt-repository -y ppa:ondrej/php
apt update
apt -y upgrade

apt install -y  php${PHP_VERSION}-bcmath php${PHP_VERSION}-cli php${PHP_VERSION}-common php${PHP_VERSION}-curl php${PHP_VERSION}-gd php${PHP_VERSION}-imap php${PHP_VERSION}-intl php${PHP_VERSION}-mbstring php${PHP_VERSION}-mysql php${PHP_VERSION}-readline php${PHP_VERSION}-soap php${PHP_VERSION}-xml php${PHP_VERSION}-xmlrpc php${PHP_VERSION}-zip

apt -y install php${PHP_VERSION}-fpm

systemctl enable php${PHP_VERSION}-fpm
systemctl restart php${PHP_VERSION}-fpm

apt -y install mariadb-client mariadb-server
systemctl enable mysql
systemctl restart mysql

echo "postfix postfix/mailname string `hostname`" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
apt -y install postfix

wget https://raw.githubusercontent.com/serverok/server-setup/master/config/nginx/conf.d/cloudflare.conf \
    -O /etc/nginx/conf.d/cloudflare.conf

systemctl restart nginx

apt -y install automysqlbackup

systemctl enable nginx
systemctl restart nginx

echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config.d/sok.conf
systemctl restart ssh

apt install -y monit
ln -s /etc/monit/conf-available/nginx /etc/monit/conf-enabled/nginx
ln -s /etc/monit/conf-available/mysql /etc/monit/conf-enabled/mysql
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


# Add swap if not available

swaptotal=$(free -m | awk '/^Swap:/ { print $2 }')

if [ "$swaptotal" -lt 1 ]; then
    echo "Creating swap space..."
    dd if=/dev/zero of=/swapfile bs=1M count=2048
    mkswap /swapfile
    if ! grep -q "swapfile" /etc/fstab; then
        echo "/swapfile swap swap defaults 0 0" | tee -a /etc/fstab
    fi
    swapon -a
    echo 0 > /proc/sys/vm/swappiness
    echo "Swap space created and configured."
else
  echo "Swap space already available."
fi

mkdir /usr/serverok/
rm -rf /usr/serverok/phpmyadmin

cd /usr/local/src
rm -f phpMyAdmin-latest-all-languages.tar.gz
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
tar xvf phpMyAdmin-latest-all-languages.tar.gz
mv phpMyAdmin-5.2.1-all-languages /usr/serverok/phpmyadmin
cd /usr/serverok/phpmyadmin/
mkdir tmp
chmod 777 tmp
cp config.sample.inc.php config.inc.php
sed -i  's/$cfg\[.blowfish_secret.\] = .*$/$cfg\["blowfish_secret"\] = "ohhae8Fa6oJohrohng0ieV0to3aiThae";/g' config.inc.php

cat <<EOL > /etc/nginx/sites-enabled/phpmyadmin.conf
server {
    listen *:7777;
    server_name _;
    root /usr/serverok/phpmyadmin/;
    index index.php;
    client_max_body_size 500M;
    proxy_read_timeout 600s;
    fastcgi_read_timeout 600s;
    fastcgi_send_timeout 600s;
    location = /favicon.ico {
            log_not_found off;
            access_log off;
    }
    location = /robots.txt {
            allow all;
            log_not_found off;
            access_log off;
    }
    location / {
            try_files \$uri \$uri/ /index.php?\$args;
    }
    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_intercept_errors on;
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
        fastcgi_pass unix:/run/php/php${PHP_VERSION}-fpm.sock;
    }
}
EOL

systemctl restart nginx
