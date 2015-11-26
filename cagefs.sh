#!/bin/bash

echo "Installing CageFS"

/bin/sed -i "s/HOMEMATCH home/HOMEMATCH /g" /etc/wwwacct.conf
yum -y install cagefs
/usr/sbin/cagefsctl --init

/bin/cp -f data/cagefs_git.cfg /etc/cagefs/conf.d/git.cfg
/bin/cp -f data/cagefs_vshare.cfg /etc/cagefs/conf.d/vshare.cfg

/usr/sbin/cagefsctl --enable-all

cagefsctl --force-update

