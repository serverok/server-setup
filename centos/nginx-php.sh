#!/bin/bash

yum -y install epel-release
yum -y install yum-utils
rpm -ivh https://rpms.remirepo.net/enterprise/remi-release-7.rpm

curl https://raw.githubusercontent.com/serverok/server-setup/master/data/centos/nginx.repo -o /etc/yum.repos.d/nginx.repo

yum -y install nginx

yum-config-manager --enable remi-php72
# If you need PHP 5.6, run
# yum-config-manager --disable remi-php72
# yum-config-manager --enable remi-php56


yum install -y php-fpm php-bcmath php-cli php-common php-devel php-gd \
    php-imap php-intl php-json php-ldap php-lz4 php-mbstring php-mysqlnd \
    php-soap php-intl php-opcache php-xml php-pdo


yum -y install mariadb mariadb-server

systemctl enable mariadb
systemctl enable nginx
systemctl enable php-fpm
systemctl start mariadb
systemctl start nginx
systemctl start php-fpm
