#!/bin/bash

yum -y install libxml2-devel libcurl-devel
yum -y install libjpeg-turbo-devel libpng-devel freetype-devel
yum -y install libmcrypt-devel


mkdir /usr/local/src
cd /usr/local/src
wget http://in1.php.net/get/php-7.0.0.tar.gz/from/this/mirror -O php-7.0.0.tar.gz
tar xf php-7.0.0.tar.gz
cd php-7.0.0
make clean
./configure --prefix=/usr/serverok/php-7.0.0 \
--with-config-file-path=/usr/serverok/php-7.0.0/etc \
--with-mysql \
--with-pdo-mysql \
--enable-cgi \
--with-zlib \
--with-gettext \
--enable-ftp \
--enable-calendar \
--enable-bcmath \
--enable-sockets \
--with-curl \
--with-gd \
--with-jpeg-dir=/usr/local \
--enable-mbstring \
--with-freetype-dir=/usr/local \
--with-mhash=/usr/local --enable-exif \
--with-mcrypt=/usr \
--with-tidy \
--with-openssl \
--enable-zip \
--enable-fpm
make && make install


cp /usr/serverok/php-7.0.0/etc/php-fpm.conf.default /usr/serverok/php-7.0.0/etc/php-fpm.conf
cp /usr/serverok/php-7.0.0/etc/php-fpm.d/www.conf.default /usr/serverok/php-7.0.0/etc/php-fpm.d/www.conf
cp php.ini-development /usr/serverok/php-7.0.0/etc/php.ini
cp ./sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod 755 /etc/init.d/php-fpm
chkconfig --add php-fpm
chkconfig php-fpm on


cd /usr/serverok/php-7.0.0/etc/

/usr/serverok/php-7.0.0/sbin/php-fpm


vi /etc/systemd/system/multi-user.target.wants/php7-fpm.service


[Unit]
Description=The PHP FastCGI Process Manager
After=syslog.target network.target

[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/php-fpm
ExecStart=/usr/serverok/php-7.0.0/sbin/php-fpm --nodaemonize
ExecReload=/bin/kill -USR2 $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target

[root@vps154294 php-7.0.0]#


vi /usr/serverok/php-7.0.0/etc/php-fpm.d/www.conf

Find

listen = 127.0.0.1:9000

Replace with

listen = /var/run/php-fpm/proxy.sock


systemctl stop php-fpm
/usr/serverok/php-7.0.0/sbin/php-fpm
