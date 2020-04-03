apt install -y curl

sed -i 's/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.0/fpm/php.ini
sed -i 's/^;date.timezone =/date.timezone = "UTC"/g' /etc/php/7.0/fpm/php.ini

apt-get install fcgiwrap -y

echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password " | debconf-set-selections

apt-get install -y phpmyadmin

cd /usr/local/bin
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
./certbot-auto --install-only

apt-get -y install pure-ftpd-common pure-ftpd-mysql quota quotatool

sed -i 's/^VIRTUALCHROOT=false/VIRTUALCHROOT=true/g' /etc/default/pure-ftpd-common

echo 1 > /etc/pure-ftpd/conf/TLS

mkdir -p /etc/ssl/private/

openssl req -x509 -nodes -days 7300 -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem

service pure-ftpd-mysql restart

apt-get -y install bind9 dnsutils

apt-get install -y haveged
systemctl enable haveged
service haveged start

apt-get install -y webalizer awstats geoip-database libtimedate-perl libclass-dbi-mysql-perl

curl -s https://gist.githubusercontent.com/serverok/2c0608c036215c79b2750bdb39d5b965/raw > /etc/cron.d/awstats

apt-get -y install build-essential autoconf automake libtool flex bison debhelper binutils

cd /tmp
wget http://olivier.sessink.nl/jailkit/jailkit-2.19.tar.gz
tar xvfz jailkit-2.19.tar.gz
cd jailkit-2.19
echo 5 > debian/compat
./debian/rules binary
cd ..
dpkg -i jailkit_2.19-1_*.deb
rm -rf jailkit-2.19*

apt-get install -y fail2ban
curl -s https://gist.githubusercontent.com/serverok/86731174d4058beda88cf41d1f113707/raw > /etc/fail2ban/jail.local
cat /etc/fail2ban/jail.local

service fail2ban restart

apt-get install -y ufw

apt-get install -y roundcube roundcube-core roundcube-mysql roundcube-plugins


nano /etc/roundcube/config.inc.php

service nginx restart

cd /tmp
wget http://www.ispconfig.org/downloads/ISPConfig-3-stable.tar.gz
tar xfz ISPConfig-3-stable.tar.gz
cd ispconfig3_install/install/

php -q install.php
