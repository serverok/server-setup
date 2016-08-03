#!/bin/bash

apt-get -y install apache2
update-rc.d apache2 enable
a2enmod rewrite

apt-get -y install php php-cli php-curl php-gd php-mysql php-imagick php-imap php-mcrypt php-json
phpenmod mcrypt

apt-get -y install mariadb-client mariadb-server
update-rc.d mysql enable

