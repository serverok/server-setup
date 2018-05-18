#!/bin/bash

apt -y install libcurl4-openssl-dev libjpeg-dev libmcrypt-dev libtidy-dev libxml2-dev libgd-dev libc-client2007e-dev build-essential
apt -y install libcurl4-openssl-dev

#ln -s /usr/include/x86_64-linux-gnu/curl /usr/include/curl


mkdir /usr/local/src
cd /usr/local/src
wget http://museum.php.net/php5/php-5.5.9.tar.xz
tar xf php-5.5.9.tar.xz
cd php-5.5.9
make clean
./configure --prefix=/usr/serverok/php-5.5.9 \
--with-config-file-path=/usr/serverok/php-5.5.9/etc \
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

make

make install
