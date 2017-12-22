#!/bin/bash

yum -y install libxml2-devel libcurl-devel

yum -y install libjpeg-turbo-devel libpng-devel freetype-devel
yum -y install libmcrypt-devel


mkdir /usr/local/src
cd /usr/local/src
wget http://php.net/get/php-7.1.12.tar.gz/from/this/mirror -O php-7.1.12.tar.gz
tar xf php-7.1.12.tar.gz
cd /usr/local/src/php-7.1.12
make clean
./configure --prefix=/usr/serverok/php-7.1.12 \
--with-config-file-path=/usr/serverok/php-7.1.12/etc \
--with-mysql \
--with-pdo-mysql \
--with-mysqli \
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



/usr/serverok/php-7.1.12/bin/php -m



cp /usr/serverok/php-7.1.12/etc/php-fpm.conf.default /usr/serverok/php-7.1.12/etc/php-fpm.conf
cp /usr/serverok/php-7.1.12/etc/php-fpm.d/www.conf.default /usr/serverok/php-7.1.12/etc/php-fpm.d/www.conf
cp php.ini-development /usr/serverok/php-7.1.12/etc/php.ini
cp ./sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod 755 /etc/init.d/php-fpm
chkconfig --add php-fpm
chkconfig php-fpm on


cd /usr/serverok/php-7.1.12/etc/

/usr/serverok/php-7.1.12/sbin/php-fpm


vi /etc/systemd/system/multi-user.target.wants/php7-fpm.service


[Unit]
Description=The PHP FastCGI Process Manager
After=syslog.target network.target

[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/php-fpm
ExecStart=/usr/serverok/php-7.1.12/sbin/php-fpm --nodaemonize
ExecReload=/bin/kill -USR2 $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target

[root@vps154294 php-7.1.12]#


vi /usr/serverok/php-7.1.12/etc/php-fpm.d/www.conf

Find

listen = 127.0.0.1:9000

Replace with

listen = /var/run/php-fpm/proxy.sock


systemctl stop php-fpm
/usr/serverok/php-7.1.12/sbin/php-fpm


[root@vps154294 systemd]# cat /etc/sysconfig/php-fpm
# Additional environment file for php-fpm

# This file is deprecated when systemd is used and
# will be removed in the future

# To alter the FPM environment, copy the unit file
# from /usr/lib/systemd/system/php-fpm.service
# to   /etc/systemd/system/php-fpm.service
# and add an Environment line

# With systemd >= 204 you can simply drop a file with the
# suffix .conf in /etc/systemd/system/php-fpm.service.d, with
#     [Service]
#     Environment=FOO=bar

# See systemd documentation.
#    man systemd.unit
#    man systemd.exec

[root@vps154294 systemd]#
