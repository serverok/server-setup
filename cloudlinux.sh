#!/bin/bash
# Author: ServerOK.in
# Email: admin@serverok.in
# Web; https://www.serverok.in

echo "Installing CageFS"

/bin/sed -i "s/HOMEMATCH home/HOMEMATCH /g" /etc/wwwacct.conf
yum -y install cagefs lvemanager
/usr/sbin/cagefsctl --init

/bin/cp -f data/cagefs_git.cfg /etc/cagefs/conf.d/git.cfg
/bin/cp -f data/cagefs_vshare.cfg /etc/cagefs/conf.d/vshare.cfg

/usr/sbin/cagefsctl --enable-all

cagefsctl --force-update

yum groupinstall -y alt-php

yum update -y cagefs lvemanager

cagefsctl --force-update
