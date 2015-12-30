#!/bin/bash

apt-get install libcurl4-openssl-dev libjpeg-dev libmcrypt-dev libtidy-dev libxml2-dev libpng12-dev libgd-dev libc-client2007e-dev build-essential

mkdir /usr/local/src
cd /usr/local/src
wget http://in1.php.net/get/php-7.0.0.tar.gz/from/this/mirror -O php-7.0.0.tar.gz
tar xf php-7.0.0.tar.gz
cd php-7.0.0
make clean
./configure --prefix=/usr/local/hostonnet/php-7.0.0 \
--with-config-file-path=/usr/local/hostonnet/php-7.0.0/etc \
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


