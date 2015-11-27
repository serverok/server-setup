#!/bin/bash

apt-get update
apt-get -y upgrade
apt-get -y install wget
apt-get -y install curl
apt-get -y install nmap
apt-get -y install whois
apt-get -y install vim

apt-get -y install apache2
update-rc.d apache2 enable
a2enmod rewrite

apt-get -y install php5 php5-cli php5-curl php5-gd php5-mysql php5-imagick php5-imap php5-mcrypt php5-json
php5enmod mcrypt

apt-get -y install mariadb-client-5.5 mariadb-server-5.5
update-rc.d mysql enable
apt-get -y install screen

