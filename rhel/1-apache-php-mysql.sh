#!/bin/bash

yum -y install httpd httpd-devel httpd-tools

yum -y install php php-cli php-devel php-gd php-intl php-mbstring php-mysqlnd php-odbc php-pdo php-process php-pspell php-soap php-xml php-xmlrpc

yum -y install mariadb mariadb-server


systemctl enable mariadb
systemctl enable httpd
service mariadb start
service httpd start
