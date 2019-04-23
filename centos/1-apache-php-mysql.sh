#!/bin/bash

yum -y install epel-release
yum -y install yum-utils
rpm -ivh https://rpms.remirepo.net/enterprise/remi-release-7.rpm

yum -y install httpd httpd-devel httpd-tools mod_ssl


yum-config-manager --enable remi-php72
# If you need PHP 5.6, run
# yum-config-manager --disable remi-php72
# yum-config-manager --enable remi-php56


yum install -y php php-bcmath php-cli php-common php-devel php-gd \
    php-imap php-intl php-json php-ldap php-lz4 php-mbstring php-mysqlnd \
    php-soap php-intl php-opcache php-xml php-pdo

yum -y install mariadb mariadb-server

systemctl enable mariadb
systemctl enable httpd
service mariadb start
service httpd start
