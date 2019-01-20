#!/bin/bash
# Author: ServerOK.in
# Email: admin@serverok.in
# Web; https://www.serverok.in

echo "Disable Shell Fork Protection"

/usr/local/cpanel/bin/install-login-profile --uninstall limits

echo "Installing CageFS"

/bin/sed -i "s/HOMEMATCH home/HOMEMATCH /g" /etc/wwwacct.conf
yum -y install cagefs lvemanager
/usr/sbin/cagefsctl --init

wget https://raw.githubusercontent.com/serverok/server-setup/master/data/cagefs_git.cfg -O /etc/cagefs/conf.d/git.cfg
wget https://raw.githubusercontent.com/serverok/server-setup/master/data/cagefs_vshare.cfg -O /etc/cagefs/conf.d/vshare.cfg

/usr/sbin/cagefsctl --enable-all

cagefsctl --force-update

yum groupinstall -y alt-php

yum update -y cagefs lvemanager

cagefsctl --force-update
